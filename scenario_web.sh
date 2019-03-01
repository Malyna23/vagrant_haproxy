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
sudo rm -rf /var/www/html/
sudo tar -zxvf moodle-latest-36.tgz -C /var/www/
sudo mv /var/www/moodle /var/www/html
sudo setsebool httpd_can_network_connect true
sudo /usr/bin/php /var/www/html/admin/cli/install.php --wwwroot=http://192.168.56.2/ --dataroot=/var/moodledata --dbtype=pgsql --dbhost=192.168.56.4 --dbport=5432 --dbname=dbname --dbuser=dbname --dbpass=dbname --fullname="Moodle" --adminpass=1Qaz2wsx$  --shortname="Moodle" --non-interactive --agree-license
sudo chmod a+r /var/www/html/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata
sudo systemctl start firewalld.service
sudo firewall-cmd --permanent --zone=public --add-rich-rule='
  rule family="ipv4"
  source address="192.168.56.2/32"
  port protocol="tcp" port="80" accept'
sudo firewall-cmd --reload
