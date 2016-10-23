#!/usr/bin/env bash

echo -e "\n--- Installing MySQL and phpMyAdmin ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install mysql-server phpmyadmin > /dev/null 2>&1

echo -e "\n--- Setting up MySQL user $user and database $database ---\n"
mysql -uroot -p$password -e "CREATE DATABASE $database" >> /dev/nulll 2>&1
mysql -uroot -p$password -e "grant all privileges on $database.* to '$user'@'localhost' identified by '$password'" > /dev/null 2>&1

echo -e "\n--- Setting phpMyAdmin to work with apache2 ---\n"
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
service apache2 restart

# TODO: Make this dynamic (load all .sql in the root folder)
if [ -f "/vagrant/database.sql" ];
then
	echo -e "\n--- Restoring database.sql in the database $database ---\n"
	mysql -uroot -p$password $database < /vagrant/database.sql > /dev/null 2>&1
fi
