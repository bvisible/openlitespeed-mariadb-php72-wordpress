#!/bin/bash
TEMPRANDSTR=
function getRandPassword
{
    dd if=/dev/urandom bs=8 count=1 of=/tmp/randpasswdtmpfile >/dev/null 2>&1
    TEMPRANDSTR=`cat /tmp/randpasswdtmpfile`
    rm /tmp/randpasswdtmpfile
    local DATE=`date`
    TEMPRANDSTR=`echo "$TEMPRANDSTR$RANDOM$DATE" |  md5sum | base64 | head -c 16`
}
getRandPassword
ROOTSQLPWD=$TEMPRANDSTR
USERSQLPWD=$TEMPRANDSTR

#Create Database
/etc/init.d/mysql start
mysql -v -e "create database wp_ls;grant all on wp_ls.* to wp_ls@localhost identified by '$USERSQLPWD'"

#update mysql root pass
mysql -uroot -v -e "use mysql;update user set Password=PASSWORD('$ROOTSQLPWD') where user='root'; flush privileges;"

#Install Wordpress
cd /home/defdomain/html/
wget --no-check-certificate http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz  >/dev/null 2>&1
mv wordpress/* ./
chown -R nobody:nobody /home/defdomain/html

#Wordpress Salt
wget -O /tmp/wp.keys https://api.wordpress.org/secret-key/1.1/salt/

#Config Wordpress
sed -e "s/database_name_here/wp_ls/" -e "s/username_here/wp_ls/" -e "s/password_here/"$USERSQLPWD"/" wp-config-sample.php > wp-config.php
sed -i '/#@-/r /tmp/wp.keys' wp-config.php
sed -i "/#@+/,/#@-/d" wp-config.php

chown -R nobody:nobody /home/defdomain/html/

#Copy and save config WordPress
cp /home/defdomain/html/wp-config.php /home/defdomain/save-config.php

#Install nano
yum install -y nano

#Install php-cli
yum install -y php-cli php-zip wget unzip

#Install composer php
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#Install php72
yum install -y epel-release
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php72
yum update -y 
yum install -y php72
yum install -y php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache
yum --enablerepo=remi-php72 install -y php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt

#Install dev tools for openlitespeed
yum groupinstall -y "Development Tools"
yum install -y libxml2-devel openssl-devel curl-devel libpng* 

#Install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#Delete Install file
rmdir wordpress
rm latest.tar.gz
rm /tmp/wp.keys