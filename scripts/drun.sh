#!/usr/bin/env bash
export PROJECT_DIR=`pwd`

set -ex

if [[ -z $1 ]]; then
  docker-compose up -d
else
  docker-compose "$@"
fi
