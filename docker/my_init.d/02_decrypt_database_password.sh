#!/usr/bin/env bash
#
# Use KMS to decrypt the database password passed to us by the mysql database resource.
# This script is run when the container is first started.
#

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
# use the awscli to decrypt the password, then base64 decode it
# see also: https://docs.aws.amazon.com/cli/latest/reference/kms/decrypt.html
PASS=$(\
 aws kms decrypt --output text --query Plaintext \
  --encryption-context "Application=${PROJECT_STACK},Database=${DRUPAL_DB_NAME}" \
  --ciphertext-blob fileb://<(echo "${DRUPAL_DB_PASSWORD_ENCRYPTED}" | base64 -d) \
  | base64 -di - \
 )

if [[ -z "${PASS}" ]]; then
  echo "Decryption failed, missing value."
  exit 1
fi
# writing the value here allows it to be used by other processes that are not sub-processes of this script.
echo "${PASS}" >> /etc/container_environment/DRUPAL_DB_PASSWORD
export DRUPAL_DB_PASSWORD="${PASS}"