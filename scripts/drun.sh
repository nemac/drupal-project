#!/usr/bin/env bash
export PWD=`pwd`
export PROJECT_NAME=nemac
PROJECT_HOSTNAME=${PROJECT_NAME//-/.}
export PROJECT_HOSTNAME=${PROJECT_HOSTNAME%.*}.test

if [[ -z $1 ]]; then
  docker-compose up -d
else
  docker-compose "$@"
fi
