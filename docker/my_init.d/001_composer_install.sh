#!/usr/bin/env bash
#
# This script is run when the container is first started.
#
set -x
set +e
#Fixes shared folder uid:gid issues.
usermod --non-unique --uid `stat -c "%u" /app` www-data

# Apache fails to start if the log directory doesn't exist.
mkdir -p /var/log/apache2
chown www-data:www-data /var/log/apache2
# Just doing this to ensure our permissions will work.
# TODO This could be removed if Drupal would stop changing permissions on files.
#chown www-data:www-data /app

#run composer install
su -s "/bin/bash" -c "cd /app/ && composer install" www-data
