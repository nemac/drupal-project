#!/usr/bin/env bash
set -ex

add-apt-repository ppa:ondrej/php
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install -y \
    wget \
    curl \
    zip \
    unzip \
    git \
    apache2 \
    php7.1 \
    php7.1-bcmath \
    php7.1-curl \
    php7.1-dom \
    php7.1-gd \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-readline \
    php7.1-zip \
;
# get CA certificates (required by curl and the s3 reverse proxy)
curl -sS https://curl.haxx.se/ca/cacert.pem > /etc/cacert.pem
echo 'openssl.cafile="/etc/cacert.pem"' >> /etc/php-7.1.ini
# Install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod 755 /usr/bin/composer

echo "ServerName \${PRIMARY_DOMAIN}" >> /etc/apache2/apache2.conf;

# Install the AWSCLI and Certbot
apt-get install -y \
    python2.7 \
    python-pip \
    awscli \
    python-certbot-apache \
;

echo "
    date.timezone = \${PHP_DATE_TIMEZONE}
    memory_limit = \${PHP_MEMORY_LIMIT}
    post_max_size = \${PHP_POST_MAX_SIZE}
    upload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}
    max_execution_time = \${PHP_MAX_EXECUTION_TIME}
    display_errors = \${ENABLE_DEBUGGING}
    error_log = \"/var/log/php.log\"
    expose_php = Off
    html_errors = Off
    variables_order = \"EGPCS\"
    session.save_path = \"/tmp\"
    default_socket_timeout = 90
    short_open_tag = 1
    allow_url_fopen = On
       " >> /etc/php/7.1/apache2/php.ini

# Install xdebug
apt-get install -y php7.1-dev
cd /tmp/
wget http://xdebug.org/files/xdebug-2.5.0.tgz
tar -xvzf xdebug-2.5.0.tgz
cd /tmp/xdebug-2.5.0
phpize
./configure
make
cp modules/xdebug.so /usr/lib/php/20160303

echo  "
    zend_extension = /usr/lib/php/20160303/xdebug.so
    xdebug.enabled=\${ENABLE_DEBUGGING}
    xdebug.remote_enable=1
    xdebug.remote_host=\${XDEBUG_REMOTE_HOST}
    xdebug.remote_autostart=1
    xdebug.remote_handler=dbgp
    xdebug.remote_mode=req
    " >> /etc/php/7.1/apache2/php.ini
apt-get remove -y php7.1-dev
# END XDEBUG

echo "
    opcache.memory_consumption=128
    opcache.interned_strings_buffer=16
    opcache.max_accelerated_files=4000
    opcache.revalidate_freq=2
    opcache.fast_shutdown=1
    opcache.enable_cli=1
    " >> /etc/php/7.1/apache2/conf.d/10-opcache.ini

#Clean up (keeps this layer slim.)
apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*