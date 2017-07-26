#!/usr/bin/env bash
if [[ -z "$1" ]]
then
    echo "Pulls specified docker image version from the ECR repository and tags it for use in local development environment."
    echo "Usage: ./pull-image version_tag"
    echo "Ex: pull-image 1.01"
    exit
fi

set -ex

$(aws ecr get-login --region us-east-1 --no-include-email)
docker pull 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1
docker tag 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1 nemac-drupal:latest