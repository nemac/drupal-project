#!/usr/bin/env bash
if [[ -z "$1" ]]
then
    echo "Pushes current local development image to AWS ECR repository with the specified version tag."
    echo "Usage: push-image version_tag\nEx: push-image 1.01"
    echo "WARNING: Always push breaking changes with a new minor revision number!"
    echo "Running containers on Elastic Beanstalk automatically update to the newest image upon code deploy or container failure."
    exit
fi

set -ex

$(aws ecr get-login --region us-east-1)
docker tag nemac-drupal-image:latest 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1
docker push 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1