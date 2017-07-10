#!/usr/bin/env bash
#
# This script is run when the container is first started.
#

composer global require hirak/prestissimo

chown www-data:www-data /.composer

#run composer install
su -s "/bin/bash" -c "cd /app/ && composer install" www-data

chmod 660 /app/web/sites/default/settings.php 2> /dev/null
echo "<?php require(dirname(\$app_root) . '/settings.php');" > /app/web/sites/default/settings.php