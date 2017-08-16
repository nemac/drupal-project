#!/usr/bin/env bash

if [[ "$(basename -- "$0")" == "commands.sh" ]]; then
    echo "Don't run $0, source it." >&2
    exit 1
fi

function dcontainer(){
  result=$(docker ps -qa --filter=name=._app_ | head -n1 )
  if [[ "$?" != "0" || "$result" = "" ]]; then
    >&2 echo "App container is not running. "
    exit 1;
  fi
  echo "$result"
}
export -f dcontainer

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

alias dps="docker ps"
alias dbash="${DIR}/scripts/dbash.sh"
alias dlog="docker-compose logs app"
alias dtail="docker-compose logs -f app"
alias drun="${DIR}/scripts/drun.sh"
alias dclean="${DIR}/scripts/dclean.sh"
alias build-image="${DIR}/scripts/build-image.sh"
alias push-image="${DIR}/scripts/push-image.sh"
alias pull-image="${DIR}/scripts/pull-image.sh"
alias composer="${DIR}/scripts/composer.sh"
alias drush="${DIR}/scripts/drush.sh"
alias sql-dump="${DIR}/scripts/sql-dump.sh"
alias sql-import="${DIR}/scripts/sql-import.sh"

# This is mirrored in the readme, if you change it here change it there for consistency.
cat <<- 'EOM'
Image management commands:
  build-image - Build the docker image for local use
  pull-image - Pulls specified docker image version from the ECR repository for local development.
  push-image - Pushes current local development image to AWS ECR repository with the specified version tag.
Local development container commands:
  drun - Runs docker-compose to start the local development environment.
    drun stop - Stops the running dev environment.
    drun down - Remove running dev environment (Add "-v" to also remove data from database/composer cache)
  dps - Lists running docker containers.
  dbash - Open a terminal in running app container
  dlog - View app container's stdouterr output
  dtail - Follow app container's stdouterr output
  dclean - Clean up local development junk (drupal database, composer dependencies, etc)
Utility commands:
  drush - Runs `drush` in running app container.
  composer - Runs `composer` in running app container.
  sql-dump - Runs `drush sql-dump` in running app container.
  sql-import - Imports sql dump from file using drush.
EOM