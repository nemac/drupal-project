#!/usr/bin/env bash
# if we are in the container, just call drush.
if [[ -e "/app/vendor/bin/drush" ]]; then

source /etc/container_environment.sh
set -x
/app/vendor/bin/drush --root=/app/web "$@"
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
docker exec --user apache -it "${APP_CONTAINER}" /bin/bash -c "/app/scripts/drush.sh $C"

