#!/usr/bin/env bash

#
# Configure Apache according to variables passed to the container.
# This script is run when the container is first started.
#

# Just changes 'true'/'false' to '0'/'1' for usage in config files.
if [[ 'true' -eq "${ENABLE_DEBUGGING}" ]]; then
  echo '1' >/etc/container_environment/ENABLE_DEBUGGING_BOOL
  # used by phpstorm/intellij to map xdebug cli connections to debugging server configurations
  echo 'serverName=drupal.local' >/etc/container_environment/PHP_IDE_CONFIG
else
  echo '0' >/etc/container_environment/ENABLE_DEBUGGING_BOOL
fi

# Enable http vhost by default
a2ensite http
# If https is enabled or forced and we have a cert
if [[ ( "$ENABLE_HTTPS" = 'true' || "$FORCE_HTTPS" = 'true' ) && -e "/etc/letsencrypt/live/${PRIMARY_DOMAIN}/fullchain.pem" ]]; then
  a2ensite https
  if [[ "$FORCE_HTTPS" = 'true' ]]; then
    a2dissite http
    a2ensite http_redirect
  fi
fi

# Enable s3 proxy if we have asset store.
if [[ ! -z "$ASSET_STORE" ]]; then
  a2enconf s3-proxy
else
  a2disconf s3-proxy
fi