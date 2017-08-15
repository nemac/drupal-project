#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR/../docker
docker image remove nemac-drupal:d8-latest
docker build . -t nemac-drupal:d8-latest "$@"
