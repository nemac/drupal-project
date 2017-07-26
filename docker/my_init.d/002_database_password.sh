#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

# Use KMS to decrypt the database password passed to us by the mysql database resource.

# soft fail if we simply don't have a password.
if [[ -z "${DRUPAL_DB_PASSWORD_ENCRYPTED}" ]]; then
  echo "DRUPAL_DB_PASSWORD_ENCRYPTED not set, skipping decryption."
  exit 0
fi
# hard fail if we have a password, but not the other required variables.
if [[ -z "${DRUPAL_DB_NAME}" || -z "${PROJECT_STACK}" ]]; then
  echo "DRUPAL_DB_NAME or PROJECT_STACK not set, decryption failed."
  exit 1
fi

PASS=$(\
 aws kms decrypt --output text --query Plaintext \
  --encryption-context "Application=${PROJECT_STACK},Database=${DRUPAL_DB_NAME}"\
  --ciphertext-blob fileb://<(echo "${DRUPAL_DB_PASSWORD_ENCRYPTED}" | base64 -d) \
  | base64 -di - \
 )

if [[ -z "${PASS}" ]]; then
  echo "Decryption failed, missing value."
  exit 1
fi

echo "${PASS}" >> /etc/container_environment/DRUPAL_DB_PASSWORD
export DRUPAL_DB_PASSWORD="${PASS}"