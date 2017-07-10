#!/usr/bin/env bash

# if we are in the container, just call drush.
if [[ -h "/app/vendor/bin/drush" ]]; then
cd /app/web && /app/vendor/bin/drush $@
exit 0;
fi

# Check that a container is running.
APP_CONTAINER=$( docker ps --no-trunc -q --filter=name=._app_)
if [[ "${APP_CONTAINER}" == "" ]]; then
  echo "App Container not running. Exiting."
  exit 1
fi;

# Escape arguments for passing to bash -c
C=''
for i in "$@"; do
    i="${i//\\/\\\\}"
    C="$C \"${i//\"/\\\"}\""
done
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
set -x;
$DIR/dbash.sh -c "cd /app/web && /app/vendor/bin/drush $C"

