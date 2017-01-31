#!/bin/bash

apt-get update;
apt-get install -y wget
apt-get install -y apt-transport-https
wget -O - https://repo.varnish-cache.org/ubuntu/GPG-key.txt | apt-key add -
echo deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0 >> /etc/apt/sources.list.d/varnish-cache.list
apt-get update
apt-get install -y varnish
apt-get install -y software-properties-common

wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list
echo deb http://archive.ubuntu.com/ubuntu trusty main universe | tee /etc/apt/sources.list
add-apt-repository -y ppa:nginx/stable
apt-get update

\
  apt-get install -y \
  hhvm-fastcgi \
  nginx \
  mysql-client

adduser --disabled-login --gecos 'Wordpress' wordpress

mkdir /home/wordpress

cp wordpress/wp_version_writer.py /home/wordpress/scripts/wp_version_writer.py
cp wordpress/wp_version_checker.py /home/wordpress/scripts/wp_version_checker.py

apt-get install -y python
mkdir /home/wordpress/builtin_wordpress; mkdir /home/wordpress/live_wordpress;
cd /home/wordpress/builtin_wordpress; wget $(python ../scripts/wp_version_writer.py) -O latest.tar.gz; tar -xvzf latest.tar.gz; rm latest.tar.gz; mv wordpress/* .; rm -R wordpress

cp nginx/nginx.conf /etc/nginx/nginx.conf
cp varnish/varnish4-wordpress /etc/varnish/default.vcl
cp start.sh /start.sh
chmod 755 /start.sh
cp wordpress/wp-config.php /home/wordpress/_config/wp-config.php
cp wordpress/production-config.php /home/wordpress/_config/production-config.php
chown wordpress:wordpress /home/wordpress/_config/*.php
chown wordpress:wordpress -R /home/wordpress/builtin_wordpress/*

ls -la /home/wordpress/builtin_wordpress

