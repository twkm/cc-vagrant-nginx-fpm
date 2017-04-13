#!/bin/bash
#
# CONFIGURE script used to provision the box this box was based on
# Originally used the ubuntu/trusty64 vagrant box
#
# Get a stripped-down bashrc
curl -# -L https://gist.githubusercontent.com/twkm/63f7b1b0a20bdd32234d9b98cb3e6d16/raw/e276a24b2525bdda372e3200e4ca246372a1000b/.bash_profile >> /home/vagrant/.bashrc

# Add PHP7 PPA repository
add-apt-repository ppa:ondrej/php

# Update APT
apt-get update

# Disable auto-run services after install
printf "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d
chmod a+x /usr/sbin/policy-rc.d

# Install NGINX
apt-get install nginx -y -q

# Install PHP7.1 and PHP-FPM
apt-get install php7.1 php7.1-fpm -y -q
apt-get install php7.1-common php7.1-sqlite3 php7.1-mbstring php7.1-mcrypt php7.1-xml php7.1-zip php7.1-intl php7.1-json -y -q
apt-get install php-imagick php-yaml -y -q

## Install Composer
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/local/bin/composer

## Change ownership of folder PHP session files
chown root:vagrant /var/lib/php/sessions

# Install SQLite3
apt-get install sqlite3 -y -q

# Configure NGINX
## Remove default configuration
rm /etc/nginx/sites-enabled/default
sed -i 's/user .*/user vagrant;/' /etc/nginx/nginx.conf

# Development Configurations
## Change NGINX User/Group
sed -i 's/user = .*/user = vagrant/' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/group = .*/group = vagrant/' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/listen.owner = .*/listen.owner = vagrant/' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/listen.group = .*/listen.group = vagrant/' /etc/php/7.1/fpm/pool.d/www.conf

## Configure PHP.ini for Development
sed -i 's/display_errors = .*/display_errors = On/' /etc/php/7.1/fpm/php.ini
sed -i 's/error_reporting = .*/error_reporting = E_ALL/' /etc/php/7.1/fpm/php.ini

# Remove package files
apt-get clean

# "Zero Out" the drive
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Clear bash history
cat /dev/null > ~/.bash_history && history -c && exit