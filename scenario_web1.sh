#!/usr/bin/bash

sudo yum -y update 

#Install web-server(Apache2)

sudo yum -y install httpd 
sudo systemctl start httpd.service      
sudo systemctl enable httpd.service

#Install php7.2

sudo yum -y install epel-release
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php72
sudo yum -y update
sudo yum -y install php php-mysql php-xml php-xmlrpc php-gd php-intl php-mbstring php-soap php-zip php-opcache php-cli php-pgsql php-pdo php-fileinfo php-curl php-common php-fpm
sudo systemctl restart httpd.service

#Install moodle 3.6

sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
sudo setsebool httpd_can_network_connect true
sudo rm -rf /var/www/html/
sudo tar -zxvf moodle-latest-36.tgz -C /var/www/
sudo mv /var/www/moodle /var/www/html
sudo mkdir /var/moodledata
sudo chmod 777 /var/moodledata
sudo touch /var/www/html/config.php
sudo chmod 777 /var/www/html/config.php
sudo echo "<?php  // Moodle configuration file

unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'pgsql';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = '192.168.56.4';
\$CFG->dbname    = 'dbname';
\$CFG->dbuser    = 'dbname';
\$CFG->dbpass    = 'dbname';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 5432,
  'dbsocket' => '',
);

\$CFG->wwwroot   = 'http://192.168.56.2';
\$CFG->dataroot  = '/var/moodledata';
\$CFG->admin     = 'admin';

\$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!" > /var/www/html/config.php
sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --zone=public --add-rich-rule='
  rule family="ipv4"
  source address="192.168.56.2/32"
  port protocol="tcp" port="80" accept'
sudo firewall-cmd --reload