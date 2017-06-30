#!/usr/bin/env bash

pushd ../docker

docker build . -t nemac-drupal-image "$@"
popd