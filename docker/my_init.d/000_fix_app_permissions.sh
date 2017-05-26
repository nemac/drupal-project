#!/usr/bin/env bash
#
# This script is run when the container is first started.
#
set -ex

# Apache fails to start if the log directory doesn't exist.
mkdir -p /var/log/apache2
chown -R www-data:www-data /var/log/apache2
# Just doing this to ensure our permissions will work.
# TODO This could be removed if Drupal would stop changing permissions on files.
chown -R www-data:www-data /app

