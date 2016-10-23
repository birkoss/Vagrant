#!/usr/bin/env bash

echo -e "\n--- Installing php5 ---\n"
apt-get -y install php5-mysql php5 php5-curl php5-mcrypt php5-gd > /dev/null 2>&1
