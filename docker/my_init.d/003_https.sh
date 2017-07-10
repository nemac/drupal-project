#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

if [[ ! "$ENABLE_HTTPS" = true ]]; then
echo "HTTPS is disabled. Skipping config."
exit 0;
fi

 # Restore the most recent backup, if any (also helps sync between instances).
if [[ -z "$SECRETS_STORE" ]]; then
 echo "No SECRETS_STORE. SSL certs will not be persisted across instances."
else
  ## download most recent files from secret store
  aws s3 sync ${SECRETS_STORE} /secrets;
  mostRecentBackup=`find ./letsecrypt_${PRIMARY_DOMAIN}_*.tar.gz -maxdepth 1 -type f | sort -r | head -1`
  if [[ ! -z "$mostRecentBackup" ]]; then
    echo "found SSL cert backup, restoring.."
    tar zxvf "$mostRecentBackup" -C /
  fi
fi

# Register certs with LetsEncrypt
echo "Verifying that ${PRIMARY_DOMAIN} routes to this instance.."
publicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "PublicIP to match: $publicIP"
for i in 1 2 3 4 5; do
  resolvedIP=$(getent hosts ${PRIMARY_DOMAIN} | head -1)
  resolvedIP="${resolvedIP:0:16}"
  resolvedIP="${resolvedIP//[[:blank:]]/}"
  if [[ "$resolvedIP" -ne "publicIP" ]]; then
    echo "ResolvedIP (${resolvedIP}) does not match publicIP (${publicIP}). Retrying in 1 minute...";
    sleep 60;
  else
    echo "Primary Domain routes to this instance correctly. Attempting cert registration/renewal."

    # Build list of cnames that should also be registered
    cnames=""
    ALTERNATE_DOMAINS=${ALTERNATE_DOMAINS// /}
    for cname in ${ALTERNATE_DOMAINS//,/ }; do
      cnames="$cnames -d $cname"
    done

    ## Run certbot, get cert only, non-interactive mode, use apache for challenge, keep existing certs if they have not yet expired, don't fail entirely if some domains don't work
    certbot certonly -n --apache --keep --allow-subset-of-names -d ${PRIMARY_DOMAIN} ${cnames} --email ${ADMIN_EMAIL} --agree-tos

    # TODO CRON for SSL cert renewal sync.
    # echo "52 0,12 * * * root certbot renew -n" > /etc/cron.d/certbot

    # Backup the certs.
    ##Generate KMS Data Key for Envelope Encryption.
    backupFile="/secrets/letsencrypt_${PRIMARY_DOMAIN}_$(date +'%Y-%m-%d_%H%M').tar.gz"
    tar zcvf ${backupFile} /secrets/letsencrypt
    s3 cp ${backupFile} ${SECRETS_STORE}
    exit
  fi
done
echo "Timed out waiting for Public Domain to be routed to this instance. Skipping cert registration."







