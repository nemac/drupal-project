#!/usr/bin/env bash

#
# This script is run when the container is first started.
#
# Wait for Drupal to bootstrap successfully (connect to database, files in place, etc),
# then attempt to activate features module and s3fs
#

source /etc/container_environment.sh

{
  while [[ "$(drush core-status | grep 'Drupal bootstrap[ ]*:[ ]*Successful')" == '' ]]; do
    sleep 30
  done
  drush pm-enable features features_ui -y

  if [[ ! -z "${ASSET_STORE}" ]]; then
    drush pm-enable s3fs -y
  fi

} &