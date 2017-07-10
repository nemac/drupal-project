#!/usr/bin/env bash

APP_CONTAINER=$( docker ps --no-trunc -q --filter=name=._app_)

if [[ "${APP_CONTAINER}" == "" ]]; then
  echo "App Container not running. Exiting."
  exit 1
fi;

(
set -x
docker exec --user www-data -t "${APP_CONTAINER}" /bin/bash -c "cd /app && composer ${*}"
)