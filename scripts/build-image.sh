#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DIR/../docker
docker build . -t nemac-drupal "$@"
