#!/bin/bash
# Get OS codename
codename=lsb_release -cs

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get autoremove

## install nginx
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo echo deb http://nginx.org/packages/mainline/ubuntu/ $codename nginx > /etc/apt/sources.list.d/nginx.list
sudo echo deb-src http://nginx.org/packages/mainline/ubuntu/ $codename nginx >> /etc/apt/sources.list.d/nginx.list
sudo apt-get update
sudo apt-get -y install nginx

## install mariadb
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository -y 'deb [arch=amd64,i386] http://mirror.mephi.ru/mariadb/repo/10.1/ubuntu wily main'
sudo apt-get update
sudo apt-get -y install mariadb-server

## install php5.6 and php7
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.0 php7.0-fpm libapache2-mod-php7.0 php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath
sudo apt-get install -y php5 php5-fpm php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl
