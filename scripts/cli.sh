#!/bin/bash

source /etc/apache2/envvars
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
chmod 777 /usr/local/bin/wp