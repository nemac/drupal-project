#!/usr/bin/env bash

APP_CONTAINER=$(dcontainer)
if [[ -z "${APP_CONTAINER}" ]]; then
  echo "App Container not running. Exiting."
  exit 1
fi;

set -ex
docker exec -it "${APP_CONTAINER}" /bin/bash "$@"
