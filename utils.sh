#!/usr/bin/env bash

if [[ "$(basename -- "$0")" == "utils.sh" ]]; then
    echo "Don't run $0, source it" >&2
    exit 1
fi

alias dps="docker ps"
alias dbash="docker exec -it \$( docker ps --no-trunc -q --filter=name=._app_) /bin/bash"
alias dlog="docker-compose logs app"
alias drun="`pwd`/scripts/drun.sh"
alias build-image="`pwd`/scripts/build-image.sh"
alias push-image="`pwd`/scripts/push-image.sh"

echo -e "Utility Commands:"
echo -e "  drun - list Docker containers"
echo -e "  dps - list running Docker containers"
echo -e "  dbash - connect to running app container"
echo -e "  dlog - view running app container's stdouterr output"
echo -e "  build-image - build the docker image for local use"
echo -e "  push-image - push the docker image to the AWS ECR repo"
