#!/usr/bin/env bash
#
# Permission fixes inside the container which do not affect the host's file permissions.
# This script is run when the container is first started.
#
set -x

# Fixes most shared folder permission issues.
if [[ `stat -c "%u" /app` != 0 ]]; then
  # By changing apache's uid we avoid having to chown all files in /app
  usermod --non-unique --uid $(stat -c "%u" /app) --gid $(stat -c "%g" /app) apache
else
  # Root owns the folder, best to just chown inside the container (slower).
  chown -R apache:apache /app
fi;

chown -R apache:apache /secrets
chmod -R o-r /secrets

# Log directories for apache and php-fpm
mkdir -p /var/log/httpd
chown apache:apache /var/log/httpd

mkdir -p /var/log/php-fpm
chown apache:apache /var/log/php-fpm