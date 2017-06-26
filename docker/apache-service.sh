#!/usr/bin/env bash
#set -ex
source /etc/apache2/envvars

if [[ -z $ASSET_STORE ]]; then
a2disconf s3-proxy --quiet
else
a2enconf s3-proxy --quiet
fi

exec apache2 -D FOREGROUND