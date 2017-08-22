#!/usr/bin/env bash

#
# This script is run when the container is first started.
#
# Checks if there are tables in the database, if not attempts to restore the most recent committed dump.
#

source /etc/container_environment.sh

drush pm-enable features features_ui -y

if [[ ! -z "${ASSET_STORE}" ]]; then
drush pm-enable s3fs -y
fi