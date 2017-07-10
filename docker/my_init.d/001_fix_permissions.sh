#!/usr/bin/env bash
#
# This script is run when the container is first started.
#
set -x

#Fixes shared folder permission issues.
if [[ `stat -c "%u" /app` != 0 ]]; then
#By changing www-data's uid we avoid having to chown all files /app
usermod --non-unique --uid `stat -c "%u" /app` www-data
else
#Root owns the folder, best to just chown.
chown www-data:www-data /app -R
fi;

# Apache fails to start if the log directory doesn't exist.
mkdir -p /var/log/apache2
chown www-data:www-data /var/log/apache2
