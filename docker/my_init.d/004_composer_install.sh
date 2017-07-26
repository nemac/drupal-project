#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

chown -R apache:apache /opt/.composer

#run composer install
su -s "/bin/bash" -c "cd /app/ && composer install" apache

mkdir -p /app/web/sites/default
chmod 660 /app/web/sites/default/settings.php 2> /dev/null
echo "<?php require('/app/settings.php');" > /app/web/sites/default/settings.php

cat > /etc/cron.d/drupal <<- EOM
# This short cron file ensures that Drupal's cronjobs are run
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# At 10minutes past the hour, every hour, run the drupal cronjobs.
10 * * * * apache "/usr/local/bin/drush --root=/app/web/ --quiet cron"
EOM