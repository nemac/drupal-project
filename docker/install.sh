#!/usr/bin/env bash
set -ex

rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum -y install \
which \
wget \
curl \
zip \
unzip \
git \
httpd \
php71w-fpm \
php71w-common \
php71w-opcache \
php71w-bcmath \
php71w-xml \
php71w-gd \
php71w-mbstring \
php71w-mcrypt \
php71w-mysql \
php71w-pecl-xdebug.x86_64 \
mysql-community-client \
awscli \
certbot-apache \
;

yum clean all
rm -f /var/log/yum.log

## get CA certificates for curl/openssl
curl -sS https://curl.haxx.se/ca/cacert.pem > /etc/cacert.pem
echo 'openssl.cafile="/etc/cacert.pem"' >> /etc/php.ini

## Install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod 755 /usr/bin/composer
export COMPOSER_ALLOW_SUPERUSER=1
composer global require hirak/prestissimo
