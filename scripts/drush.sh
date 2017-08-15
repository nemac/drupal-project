#!/usr/bin/env bash
# If we are in the container, just call drush.
if [[ -e "/app/vendor/bin/drush" ]]; then
  source /etc/container_environment.sh
  set -x
  /app/vendor/bin/drush --root=/app/web "$@"
  exit 0;
fi

APP_CONTAINER=$(dcontainer)
if [[ -z "${APP_CONTAINER}" ]]; then
  echo "App Container not running. Exiting."
  exit 1
fi;

# Escape arguments for passing to bash -c
C=''
for i in "$@"; do
    i="${i//\\/\\\\}"
    C="$C \"${i//\"/\\\"}\""
done

set -x;
docker exec --user apache -it "${APP_CONTAINER}" /bin/bash -c "/app/scripts/drush.sh $C"

