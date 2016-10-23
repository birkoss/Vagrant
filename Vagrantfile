# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	# Which box to use
  config.vm.box = "precise64"

	# Sync the www folder to the web server folder
	config.vm.synced_folder "./", "/var/www"

	# Change the hostname
	config.vm.hostname = "vagrant"

	# Port fowarding for port > 1024
	config.vm.network "forwarded_port", guest:80, host:8080

	# Set a private network (host-only)
	config.vm.network "private_network", ip:"192.168.206.10"

	# Enable multiple .vagrant/provisions
	config.vm.provision "shell", inline:<<-SHELL
		apt-get update > /dev/null 2>&1
	SHELL
	config.vm.provision "shell", path:".vagrant/provisions/apache2.sh"
	config.vm.provision "shell", path:".vagrant/provisions/php5.sh"
	config.vm.provision "shell", path:".vagrant/provisions/mysql.sh", env: {"database"=>"db_test","birkoss"=>"user","password"=>"sway"}

end
