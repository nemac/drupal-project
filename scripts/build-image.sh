#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd $DIR/../docker

docker build . -t nemac-drupal-image "$@"
popd