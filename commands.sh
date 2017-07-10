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
alias checkout-image="`pwd`/scripts/checkout-image.sh"
alias composer="`pwd`/scripts/composer.sh"
alias drush="`pwd`/scripts/drush.sh"
alias sql-dump="`pwd`/scripts/sql-dump.sh"
alias sql-import="`pwd`/scripts/sql-import.sh"
alias alog="`pwd`/scripts/dbash.sh -c \"less /var/log/apache2/error.log\""
alias atail="`pwd`/scripts/dbash.sh -c \"tail -f /var/log/apache2/error.log\""

echo -e "\nImage management commands:"
echo -e "  build-image - build the docker image for local use"
echo -e "  checkout-image - build the docker image for local use"
echo -e "  push-image - Pushes current local development image to AWS ECR repository with the specified version tag."
echo -e "\nLocal development container commands:"
echo -e "  drun - list Docker containers"
echo -e "  dps - list running Docker containers"
echo -e "  dbash - open a terminal in running app container"
echo -e "  dlog - view running app container's stdouterr output"
echo -e "  dtail - follow running app container's stdouterr output"
echo -e "  alog - view running app container's apache2 error log"
echo -e "  atail - follow running app container's error log"
echo -e "\nUtility commands:"
echo -e "  drush - Runs \`drush\` in running app container."
echo -e "  composer - Runs \`composer\` in running app container."
echo -e "  sql-dump - Runs \`drush sql-dump\` in running app container."
echo -e "  sql-import - Imports sql dump from file using drush."
