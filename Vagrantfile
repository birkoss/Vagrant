# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	# Which box to use
	# ubuntu/yakkety64 = 16.10
	# ubuntu/trusty64 = 14.04
	# ubuntu/xenial64 = 16.04
	# centos/7
  config.vm.box = "ubuntu/trusty64"

	# Sync the www folder to the web server folder
#	config.vm.synced_folder "./", "/var/www/html"

	# Change the hostname
	config.vm.hostname = "vagrant"

	# Port fowarding for port > 1024
	config.vm.network "forwarded_port", guest:80, host:8080

	# Set a private network (host-only)
	config.vm.network "private_network", ip:"192.168.206.10"

	# Enable multiple .vagrant/provisions
	config.vm.provision "shell", inline:<<-SHELL
		# Misc variables
		INSTALL_APACHE="yes"
		INSTALL_PHP="5.6"
		INSTALL_MYSQL="yes"
		INSTALL_PMA="yes"

		DATABASE_NAME="db_test"
		DATABASE_USERNAME="birkoss"
		DATABASE_PASSWORD="sway"
		
		apt-get update > /dev/null 2>&1

		# Apache 2
		if [ "$INSTALL_APACHE" == "yes" ];
		then
			echo -e "\n--- Installing apache2 ---\n"
			apt-get install -y apache2 > /dev/null 2>&1

			echo -e "\n--- Enabling mod-rewrite ---\n"
			a2enmod rewrite > /dev/null 2>&1

			echo -e "\n--- Allowing Apache override to all ---\n"
			sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf


		
			# Remove the default Apache folder, and link ours
			if [ ! -h /var/www/html ];
			then 
					rm -rf /var/www/html
					ln -s /vagrant /var/www/html
			fi
	
		fi

		# Php
		case "$INSTALL_PHP" in
			5.5 | 5.6)
				apt-get install -y python-software-properties > /dev/null 2>&1
				add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
				apt-get update > /dev/null 2>&1

				echo -e "\n--- Installing php$INSTALL_PHP ---\n"
				apt-get -y install php$INSTALL_PHP-mbstring php$INSTALL_PHP-mysql php$INSTALL_PHP php$INSTALL_PHP-curl php$INSTALL_PHP-mcrypt php$INSTALL_PHP-gd > /dev/null 2>&1
				;;
			7 | 7.0)
				echo -e "\n--- Installing php7 ---\n"
				apt-get -y install php7.0-mysql php7.0 php7.0-curl php7.0-mcrypt php7.0-gd > /dev/null 2>&1
				;;
		esac

		# Mysql
		if [ "$INSTALL_MYSQL" == "yes" ];
		then
			echo -e "\n--- Installing MySQL ---\n"
			debconf-set-selections <<< "mysql-server mysql-server/root_password password $DATABASE_PASSWORD"
			debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DATABASE_PASSWORD"
			apt-get -y install mysql-server > /dev/null 2>&1

			echo -e "\n--- Setting up MySQL user $DATABASE_USERNAME and database $DATABASE_NAME ---\n"
			mysql -uroot -p$DATABASE_PASSWORD -e "CREATE DATABASE $DATABASE_NAME" >> /dev/nulll 2>&1
			mysql -uroot -p$DATABASE_PASSWORD -e "grant all privileges on $DATABASE_NAME.* to '$DATABASE_USERNAME'@'localhost' identified by '$DATABASE_PASSWORD'" > /dev/null 2>&1

			if [ "$INSTALL_PMA" == "yes" ];
			then
				echo -e "\n--- Installing phpMyAdmin ---\n"
				mkdir /var/www/phpmyadmin
				cd /var/www/phpmyadmin
				wget "https://files.phpmyadmin.net/phpMyAdmin/4.6.4/phpMyAdmin-4.6.4-english.tar.gz" -O phpMyAdmin.tar.gz > /dev/null 2>&1
				tar zxvf phpMyAdmin.tar.gz --strip-components 1 > /dev/null 2>&1
				rm phpMyAdmin.tar.gz
				cp config.sample.inc.php config.inc.php

				echo -e "\n--- Configuring phpMyAdmin to allow quick access ---\n"
				sed -i "s/'cookie';/'config'; \\\$cfg['Servers'][\\\$i]['user'] = '$DATABASE_USERNAME'; \\\$cfg['Servers'][\\\$i]['password'] = '$DATABASE_PASSWORD';/g" /var/www/phpmyadmin/config.inc.php

				if [ "$INSTALL_APACHE" == "yes" ];
				then
					echo -e "\n--- Setting phpMyAdmin to work with apache2 ---\n"
					echo "Alias /phpmyadmin "/var/www/phpmyadmin/"
					<Directory "/var/www/phpmyadmin/">
							Order allow,deny
							Allow from all
							# New directive needed in Apache 2.4.3: 
							Require all granted
					</Directory>" >> /etc/apache2/apache2.conf

					service apache2 restart
				fi
			fi

			# TODO: Make this dynamic (load all .sql in the root folder)
			if [ -f "/vagrant/database.sql" ];
			then
				echo -e "\n--- Restoring database.sql in the database $DATABASE_NAME ---\n"
				mysql -uroot -p$DATABASE_PASSWORD $DATABASE_NAME < /vagrant/database.sql > /dev/null 2>&1
			fi
		fi

	SHELL

end
