#!/usr/bin/env bash

#
# Sync secrets (SSL certs, hash salts, etc) from given secret store.
# Secrets are encrypted using AWS KMS and envelope encryption.
# See also: https://www.linkedin.com/pulse/aws-kms-envelope-encryption-james-wells
#
source /etc/container_environment.sh
if [[ -z "$SECRETS_STORE" ]]; then
  echo "No SECRETS_STORE configured. Backup/Restore Failed."
  exit 1;
fi

bucket=$(echo "$SECRETS_STORE" | sed -nr -e 's/[s3:]*[/]*([^/]+?)[/]+.*/\1/p')
prefix=$(echo "$SECRETS_STORE" | sed -nr -e 's/[s3:]*[/]*[^/]+?[/]*(.*)\//\1/p')

# Gets timestamp of most recent backup in S3
getLatestTimestampFromS3() {
  timestamp=$(aws s3api head-object --bucket="$bucket" --key="${prefix}/${PRIMARY_DOMAIN}.tgz" --query=LastModified --output=text)
  if [[ "$?" = "0" ]]; then
    echo "${timestamp}"
  fi
}

# Gets md5 checksum of /secrets
getCurrentChecksum() {
  # tar secrets, ignoring timestamps and backups, then md5sum
  tar -cf - --exclude='/secrets/.[^/]*' --mtime='1970-01-01' --exclude-backups /secrets 2>/dev/null | md5sum | cut -f 1 -d " "
}

# Archive secrets, then use KMS data key to encrypt via envelope encryption.
backup() {
  set -e
  echo "Beginning secrets backup..."
  dataKeyRequest=$(aws kms generate-data-key  \
 --key-id=alias/cloudformation  \
 --encryption-context="{\"Application\":\"${PROJECT_STACK}\",\"PrimaryDomain\":\"${PRIMARY_DOMAIN}\"}"  \
 --key-spec=AES_256  \
)
  plaintextKey=$(echo "${dataKeyRequest}" | sed -nr -e 's/.*"Plaintext"[ ]*:[ ]*\"([^"^]+?)\".*/\1/p' | base64 --decode)
  if [[ "$?" != "0" || -z "${plaintextKey}" ]]; then
    echo "Data key generation failed with result:"
    echo "${dataKeyRequest}"
    exit 0;
  fi

  # create a new temporary directory with 700 permissions
  tmpDir=$(mktemp -d)
  # write out encrypted key (comes to us pre-encoded as Base64)
  echo "${dataKeyRequest}" | sed -nr -e 's/.*"CiphertextBlob"[ ]*:[ ]*"([^"^]+?)".*/\1/p' >"${tmpDir}/datakey.key.b64"
  # tar secrets
  tar zcvf "${tmpDir}/secrets.tgz" --exclude='/secrets/.[^/]*' /secrets
  # encrypt tar
  openssl enc -e -aes256 -in "${tmpDir}/secrets.tgz" -out "${tmpDir}/secrets.tgz.enc" -k "${plaintextKey}"
  unset plaintextKey
  # envelope (tar) payload and encrypted key
  tar zcvf "${tmpDir}/${PRIMARY_DOMAIN}.tgz" --directory="${tmpDir}" "secrets.tgz.enc" "datakey.key.b64"
  # upload to s3
  aws s3 cp "${tmpDir}/${PRIMARY_DOMAIN}.tgz" "s3://${bucket}/${prefix}/${PRIMARY_DOMAIN}.tgz"
  getLatestTimestampFromS3 >/secrets/.last_synced
  getCurrentChecksum >/secrets/.last_md5
  echo 'Backup complete!'
  # cleanup
  rm -rf ${tmpDir}
}

# Restores the given backup file
restore() {
  set -e
  echo "Beginning secrets restore..."
  tmpDir=$(mktemp -d)
  # extract the envelope contents
  tar xzvf "$1" -C "$tmpDir"
  # decode the data key
  cat "${tmpDir}/datakey.key.b64" | base64 --decode >"${tmpDir}/datakey.key"
  # use kms to decrypt the data key
  plaintextKey=$(aws kms decrypt  \
 --ciphertext-blob "fileb://${tmpDir}/datakey.key"  \
 --encryption-context="{\"Application\":\"${PROJECT_STACK}\",\"PrimaryDomain\":\"${PRIMARY_DOMAIN}\"}"  \
 --output text  \
 --query Plaintext  \
 | base64 --decode  \
)
  # decrypt the payload
  openssl enc -d -aes256 -in "${tmpDir}/secrets.tgz.enc" -out "${tmpDir}/secrets.tgz" -k "${plaintextKey}"
  # extract into secrets
  tar xzf "${tmpDir}/secrets.tgz" -C /secrets --strip-components 1 --overwrite
  getLatestTimestampFromS3 >/secrets/.last_synced
  getCurrentChecksum >/secrets/.last_md5
  echo 'Restore complete!'
  # cleanup
  rm -rf ${tmpDir}
}

# Synchronizes secrets by restoring a newer backup (if any) from S3, or backing up secrets if secrets has changed.
synchronize() {
  tmpFile=$(mktemp)
  echo 'Starting secret synchronization...'
  # First, check if there is a newer backup we should download.
  if [[ -e '/secrets/.last_synced' ]]; then
    # Compare to last_synced timestamp if available
    last_synced=$(cat '/secrets/.last_synced')
    aws s3api get-object --if-modified-since="${last_synced}" --bucket="$bucket" --key="${prefix}/${PRIMARY_DOMAIN}.tgz" "${tmpFile}" 2>/dev/null
  else
    # Never synced to this container before, just download the current backup.
    aws s3api get-object --bucket="$bucket" --key="${prefix}/${PRIMARY_DOMAIN}.tgz" "${tmpFile}" 2>/dev/null
  fi
  if [[ "$?" = "0" && -s "$tmpFile" ]]; then
    # If we received a file, attempt to restore it.
    restore "$tmpFile"
  else
    # Since we didn't get a file (not newer than what we have or doesn't exist)
    if [[ -e '/secrets/.last_md5' ]]; then
      # check if the contents of /secrets have changed since the last backup/restore.
      currentChecksum=$(getCurrentChecksum)
      if [[ ! -z "$currentChecksum" && $currentChecksum != $(cat '/secrets/.last_md5') ]]; then
        echo 'Contents have changed since last backup/restore, backing up...'
        backup
      else
        echo 'Nothing changed, skipping backup.'
      fi
    else
      # No backup has been made from this container, but no backup exists in S3, create this initial backup.
      echo 'No previous back up found, backing up...'
      backup
    fi
  fi
  # clean up
  rm -rf ${tmpFile}
}

if [[ -z "$1" ]]; then
  synchronize
else
  case "$1" in
    'backup')
      backup
    ;;
    'sync')
      synchronize
    ;;
    'restore')
      if [[ -z "$2" ]]; then
        echo "Requires path to backup"
        exit 1;
      fi
      restore $2
    ;;
    '-h' | '--help' | *)
      echo -e "
Usage: sync-secrets.sh [command] [file]
Commands:
  sync - Synchronizes secrets (preferring remote backup to local changes)
  backup - backs up secrets to S3 immediately.
  restore <file> - restores the given encrypted backup."
    ;;
  esac
fi