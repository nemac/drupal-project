#!/usr/bin/env bash

APP_CONTAINER=$(dcontainer)
if [[ -z "${APP_CONTAINER}" ]]; then
  echo "App Container not running. Exiting."
  exit 1
fi;

set -x
docker exec --user apache -it "${APP_CONTAINER}" /bin/bash -c "cd /app && composer ${*}"
