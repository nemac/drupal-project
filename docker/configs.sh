#!/usr/bin/env bash
set -e

#
# Apache/httpd config
#
rm -rf /etc/httpd/conf.d
#rm -rf /etc/httpd/conf
mkdir /etc/httpd/conf-enabled
mkdir /etc/httpd/sites-enabled
mkdir /etc/httpd/mods-enabled
ln -sf /etc/httpd/
echo '
source /etc/container_environment.sh
OPTIONS="-f /etc/httpd/httpd.conf"
' >> /etc/sysconfig/httpd

a2enconf security vhost_app php
a2ensite http

#
# PHP config
#
cat >> /etc/php.ini <<- EOM
    date.timezone = \${PHP_DATE_TIMEZONE}
    memory_limit = \${PHP_MEMORY_LIMIT}
    post_max_size = \${PHP_POST_MAX_SIZE}
    upload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}
    max_execution_time = \${PHP_MAX_EXECUTION_TIME}
    display_errors = \${ENABLE_DEBUGGING_BOOL}
    error_log = \"/var/log/php.log\"
    expose_php = Off
    html_errors = Off
    variables_order = \"EGPCS\"
    session.save_path = \"/tmp\"
    default_socket_timeout = 90
    short_open_tag = 1
    allow_url_fopen = On
EOM

echo "pm.max_requests = 300" >> /etc/php-fpm.d/www.conf

cat >> /etc/php.d/xdebug.ini <<- EOM
    xdebug.enabled=\${ENABLE_DEBUGGING_BOOL}
    xdebug.remote_enable=\${ENABLE_DEBUGGING_BOOL}
    xdebug.remote_port=9001
    xdebug.remote_host=\${XDEBUG_REMOTE_HOST}
    xdebug.remote_autostart=\${ENABLE_DEBUGGING_BOOL}
    xdebug.remote_handler=dbgp
    xdebug.remote_mode=req
    xdebug.idekey="drupal"
    xdebug.max_nesting_level=350
EOM

# Restrict configs
chmod -R 655 /etc/httpd /etc/my_init.d /etc/php*