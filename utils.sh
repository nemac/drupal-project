#!/usr/bin/env bash

if [[ "$(basename -- "$0")" == "utils.sh" ]]; then
    echo "Don't run $0, source it." >&2
    exit 1
fi

alias dps="docker ps"
alias dbash="`pwd`/scripts/dbash.sh"
alias dlog="docker-compose logs app"
alias drun="`pwd`/scripts/drun.sh"
alias build-image="`pwd`/scripts/build-image.sh"
alias push-image="`pwd`/scripts/push-image.sh"
alias composer="`pwd`/scripts/composer.sh"
alias drush="`pwd`/scripts/drush.sh"

echo -e "\nImage management commands:"
echo -e "  build-image - build the docker image for local use"
echo -e "  checkout-image - build the docker image for local use"
echo -e "  push-image - Pushes current local development image to AWS ECR repository with the specified version tag."
echo -e "\nLocal development environment commands:"
echo -e "  drun - list Docker containers"
echo -e "  dps - list running Docker containers"
echo -e "  dbash - connect to running app container"
echo -e "  dlog - view running app container's stdouterr output"
echo -e "  drush - Runs `drush` in running app container."
echo -e "  composer - Runs `composer` in running app container."