#!/usr/bin/env bash
if [[ -z "$1" ]]
then
    echo "Pushes current local development image to AWS ECR repository with the specified version tag."
    echo "Usage: push-image <version_tag>"
    echo "Ex: push-image d8-1.06"
    echo "WARNING: Always push breaking changes with a new minor revision number!"
    echo "Running containers on Elastic Beanstalk automatically update to the newest image upon code deploy or container failure."

    echo 'Here are the images in the AWS ECR repository:'
    set -ex
    $(aws ecr get-login --region us-east-1 --no-include-email)
    docker images 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal
    exit
fi

set -ex

$(aws ecr get-login --region us-east-1 --no-include-email)

[[ "$?" -eq '0' ]] && echo 'AWS ECR login failed. You may need to update your AWS CLI or ensure that your credentials are set properly using `aws configure`'

docker tag nemac-drupal:d8-latest 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1
docker push 104538610210.dkr.ecr.us-east-1.amazonaws.com/nemac-drupal:$1