#!/usr/bin/env bash
export PROJECT_DIR=`pwd`
export PROJECT_NAME=$(dirname "$PROJECT_DIR")
export AWS_ACCESS_KEY_ID=`sed -nE "/\[${AWS_DEFAULT_PROFILE-default}\]/,/\[.*\]/{/aws_access_key_id/s/(.*)=[[:space:]]*(.*)/\2/p;}" ~/.aws/credentials`
export AWS_SECRET_ACCESS_KEY=`sed -nE "/\[${AWS_DEFAULT_PROFILE-default}\]/,/\[.*\]/{/aws_secret_access_key/s/(.*)=[[:space:]]*(.*)/\2/p;}" ~/.aws/credentials`

if [[ -z $1 ]]; then
  set -x
  docker-compose up -d
else
  set -x
  docker-compose "$@"
fi
