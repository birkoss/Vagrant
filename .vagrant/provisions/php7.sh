#!/usr/bin/env bash

echo -e "\n--- Installing php7 ---\n"
apt-get -y install php7.0-mysql php7.0 php7.0-curl php7.0-mcrypt php7.0-gd > /dev/null 2>&1
