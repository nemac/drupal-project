#!/usr/bin/env bash
#set -ex
source /etc/apache2/envvars

a2dissite "*" --quiet
if [[ $FORCE_HTTPS = true ]]; then
  a2ensite http_redirect --quiet
  a2ensite https --quiet
else
  a2ensite http --quiet
  if [[ $ENABLE_HTTPS = true ]]; then
  a2ensite https --quiet
  fi
fi

if [[ -z $ASSET_STORE ]]; then
  a2disconf s3-proxy --quiet
else
  a2enconf s3-proxy --quiet
fi

exec apache2 -D FOREGROUND