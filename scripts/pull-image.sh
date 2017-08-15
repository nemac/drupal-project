#!/usr/bin/env bash
if [[ -z "$1" ]]
then
    echo "Pulls specified docker image version from the ECR repository and tags it for use in local development environment."
    echo "Usage: ./pull-image <version_tag>"
    echo "Ex: pull-image d8-1.06"

    $(aws ecr get-login --region us-east-1 --no-include-email)
    echo 'Here are the currently tagged images in the AWS ECR repository:'
    docker images 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal
    exit
fi

set -ex

$(aws ecr get-login --region us-east-1 --no-include-email)
docker pull 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1
docker tag 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1 nemac-drupal:d8-latest