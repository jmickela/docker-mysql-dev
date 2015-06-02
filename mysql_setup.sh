#!/bin/bash

if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysql_install_db
fi

echo 'Starting mysql to set root password'
service mysql start
sleep 10s

echo 'loading default database'
zcat /usr/share/doc/phpmyadmin/examples/create_tables.sql.gz | mysql -u root

echo 'setting root password'
mysql -u root -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY 'rootid';"

echo 'setting admin password'
mysqladmin -u root password 'rootid'

service php5-fpm start
nginx