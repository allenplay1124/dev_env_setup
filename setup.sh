#!/bin/bash
# install isb-release model
sudo apt-get update
sudo apt-get -y install lsb-release
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
elif [ ${codename} = 'sonya' ]; then
    codename=xenial
else
    codename=${codename}
fi

while read -r -p "Is your OS version ${codename} ?(Y/N)" response
do
    if [ "${response}" = "Y" ]; then
        break;
    fi
done

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get autoremove

## fix chinese font error
sudo apt-get -y remove fonts-arphic-ukai fonts-arphic-uming

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

sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.0 php7.0-fpm libapache2-mod-php7.0 php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-cli php7.0-mcrypt php7.0-curl php7.0-intl php7.0-xsl php7.0-mbstring php7.0-zip php7.0-bcmath
sudo apt-get install -y php5.6 php5.6-fpm php5.6-common php5.6-mcrypt php5.6-gmp php5.6-curl php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-xsl php5.6-mbstring php5.6-xml
sudo apt-get install -y php-mongodb php-redis php-geoip
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
