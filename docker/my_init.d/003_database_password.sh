#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

# Use KMS to decrypt the database password passed to us by the mysql database resource.

# soft fail if we simply don't have a password.
if [[ -z "${DRUPAL_DB_PASSWORD}" ]]; then
  echo "DRUPAL_DB_PASSWORD not set, skipping decryption."
  exit 1
fi
# hard fail if we have a password, but not the other required variables.
if [[ -z "${DRUPAL_DB_NAME}" || -z "${APPLICATION}" ]]; then
  echo "DRUPAL_DB_NAME or APPLICATION not set, decryption failed."
  exit 1
fi

PASS=$(\
 aws kms decrypt --output text --query Plaintext \
  --encryption-context "Application=${APPLICATION},Database=${DRUPAL_DB_NAME}"\
  --ciphertext-blob fileb://<(echo "${DRUPAL_DB_PASSWORD}" | base64 -d) \
  | base64 -di - \
 )

if [[ -z "${PASS}" ]]; then
  echo "Decryption failed, missing value."
  exit 1
fi

echo "export DRUPAL_DB_PASSWORD_DECRYPTED=${PASS}" >> /etc/profile.d/drupal_db_password_decrypted.sh
