#!/usr/bin/env bash

if [[ "$(basename -- "$0")" == "commands.sh" ]]; then
    echo "Don't run $0, source it." >&2
    exit 1
fi

alias dps="docker ps"
alias dbash="`pwd`/scripts/dbash.sh"
alias dlog="docker-compose logs app"
alias dtail="docker-compose logs -f app"
alias drun="`pwd`/scripts/drun.sh"
alias build-image="`pwd`/scripts/build-image.sh"
alias push-image="`pwd`/scripts/push-image.sh"
alias pull-image="`pwd`/scripts/pull-image.sh"
alias composer="`pwd`/scripts/composer.sh"
alias drush="`pwd`/scripts/drush.sh"
alias sql-dump="`pwd`/scripts/sql-dump.sh"
alias sql-import="`pwd`/scripts/sql-import.sh"

# This is mirrored in the readme, if you change it here change it there for consistency.
cat <<- EOM
Image management commands:
  build-image - Build the docker image for local use
  pull-image - Pulls specified docker image version from the ECR repository for local development.
  push-image - Pushes current local development image to AWS ECR repository with the specified version tag.
Local development container commands:
  drun - List Docker containers
  dps - Lists running docker containers.
  dbash - Open a terminal in running app container
  dlog - View running app container's stdouterr output
  dtail - Follow running app container's stdouterr output
Utility commands:
  drush - Runs \`drush\` in running app container.
  composer - Runs \`composer\` in running app container.
  sql-dump - Runs \`drush sql-dump\` in running app container.
  sql-import - Imports sql dump from file using drush.
EOM