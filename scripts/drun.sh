#!/usr/bin/env bash
export PROJECT_DIR=`pwd`
export S3_ACCESS_KEY_ID=`sed -n "/^\[${AWS_DEFAULT_PROFILE-default}\]/ { :l /^aws_access_key_id[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" ~/.aws/credentials`
export S3_SECRET_ACCESS_KEY=`sed -n "/^\[${AWS_DEFAULT_PROFILE-default}\]/ { :l /^aws_secret_access_key[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" ~/.aws/credentials`

set -ex

if [[ -z $1 ]]; then
  docker-compose up -d
else
  docker-compose "$@"
fi
