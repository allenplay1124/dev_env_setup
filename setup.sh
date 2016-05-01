#!/bin/bash
# Get OS codename
codename="$(lsb_release -cs)"

if [ ${codename} = 'rosa' ]; then
    codename=trusty
elif [ ${codename} = 'rafaela' ]; then
    codename=trusty
elif [ ${codename} = 'rebecca' ]; then
    codename=trusty
elif [ ${codename} = 'qiana' ]; then
    codename=trusty
elif [ ${codename} = 'maya' ]; then
    codename=precise
else
    codename=codename
fi

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get autoremove

## install nginx
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo echo deb http://nginx.org/packages/mainline/ubuntu/ ${codename} nginx > /etc/apt/sources.list.d/nginx.list
sudo echo deb-src http://nginx.org/packages/mainline/ubuntu/ ${codename} nginx >> /etc/apt/sources.list.d/nginx.list
sudo apt-get update
sudo apt-get -y install nginx

## install mariadb
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository -y "deb [arch=amd64,i386] http://mirror.mephi.ru/mariadb/repo/10.1/ubuntu ${codename} main"
sudo apt-get update
sudo apt-get -y install mariadb-server

## install php5.6 and php7
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.0 php7.0-fpm libapache2-mod-php7.0 php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath
sudo apt-get install -y php5 php5-fpm php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl

## install git
sudo apt-get install -y libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo git clone https://github.com/git/git.git
cd git
while read -r -p 'Select install git version ? (If you want get git version list, input "L")' response
do
    if [ "${response}" = "L" ]; then
        git tag
    elif [ -n "$(git tag | grep ${response})" ]; then
        tag="$(git tag | grep ${response})"
        break;
    fi
done

sudo git checkout ${tag}
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install

cd ../
sudo rm -rf git/

## install nodejs
sudo apt-get install -y python-software-properties python g++ make
sudo apt-get install -y wget curl build-essential openssl libssl-dev
sudo git clone https://github.com/nodejs/node.git
cd node
while read -r -p 'Select install nodejs version ? (If you want get nodejs version list, input "L")' response
do
    if [ "${response}" = "L" ]; then
        git tag
    elif [ -n "$(git tag | grep ${response})" ]; then
        tag="$(git tag | grep ${response})"
        break;
    fi
done
sudo git checkout ${tag}
sudo ./configure
sudo make && make install

## install npm
sudo wget https://npmjs.org/install.sh --no-check-certificate
sudo chmod 777 install.sh
sudo ./install.sh
cd ../
rm -rf node

echo "install success!"
