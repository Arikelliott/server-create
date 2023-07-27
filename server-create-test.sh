#! /bin/bash

program_name="server-create.sh"
version=v0.0.1
config="/usr/local/etc/server-create/server-create.conf"



# - - - - - ACTUAL SCRIPT STARTS HERE!!! - - - - -

# - - - - - INITIAL - - - - -
echo -e "Using ${program_name}, version ${version}."
echo -e "\033[31mCAUTION! This script requires sudo privileges; mistyped file paths, etc. may cause file loss and other problems!\033[0m"
echo ""
echo "Using default configuration file. Config is located at $config"
echo ""

# - - - - - SITEKEY AND MYSQL PASSWORD - - - - -
# read sitekey
echo -e "Enter website name to create (example: \"yourwebsite\")"
read sitekey_raw
echo -e "Enter toplevel domain (example: \".com, .org, etc\")"
read toplevel_domain
# make sure sitekey has no ".com" at the end but sitedomain does
sitekey=$(echo ${sitekey_raw} | sed "s/$toplevel_domain//g")
sitedomain=$sitekey$toplevel_domain
escapedomain=$sitekey\\$toplevel_domain
# ask user if sitedomain is correct, exit if not
echo "Your website will be called ${sitedomain}"
echo "Use this domain name? (y/N)"
read use_domain
if [ "$use_domain" = "y" ]; then
    echo "Using $sitedomain as domain name"
else
    echo "Exiting script."
    exit 0
fi
# ask for mysql root password
echo "Enter MySQL database root-user password:"
read -s mysql_root_dbpassword
echo "Entered!"

# - - - - - MYSQL DATABASE - - - - -
# make mysql variables
mysql_root_user="root"
mysql_database="${sitekey}_wordpress"
mysql_database_user="${sitekey}_wpuser"
mysql_database_password="${sitekey}wp1"
# create mysql database
echo "Creating MySQL database."
mysql_makedb="CREATE DATABASE IF NOT EXISTS $mysql_database; CREATE USER '$mysql_database_user' IDENTIFIED BY '$mysql_database_password'; GRANT ALL PRIVILEGES ON ${mysql_database}.* TO '$mysql_database_user'; FLUSH PRIVILEGES;"
sudo mysql --user="$mysql_root_user" --password="$mysql_root_password" --execute="$mysql_makedb"
echo "Database $mysql_database created!"

# - - - - - WORDPRESS FILES - - - - -
# html root directory (typically /var/www/html)
html_root="/var/www/html"
# create sitekey folders
sudo mkdir -p $html_root/$sitekey/public_html
# copy template files to new wordpress directory
echo "Creating Wordpress files at $html_root/$sitekey/public_html."
sudo cp -vr $html_root/TEMPLATE/wordpress/* $html_root/$sitekey/public_html
# modify wp-config.php to include sitekey
sudo sed -i "s/!!KEY!!/$sitekey/g" $html_root/$sitekey/public_html/wp-config.php

# - - - - - IMPORT DATABASE TEMPLATE - - - - -
# copy initdb.sql template
sudo cp -v $html_root/initdb.sql $html_root/$sitekey/public_html/initdb.sql
# set sitekey and site domain in initdb.sql
sudo sed -i "s/!!KEY!!/$sitekey/g" $html_root/$sitekey/public_html/initdb.sql
sudo sed -i "s/!!DOMAIN!!/$sitedomain/g" $html_root/$sitekey/public_html/initdb.sql
# add initdb.sql to mysql database
mysql --user="$mysql_root_user" --password="$mysql_root_password" $mysql_database < $html_root/$sitekey/public_html/initdb.sql
# unset mysql password (protects against reading the mysql database password)
unset mysql_root_dbpassword

# - - - - - SET UP APACHE - - - - -
# make apache variables
apache_config="${sitekey}.conf"
# copy apache template file
sudo cp -v /etc/apache2/sites-available/TEMPLATE.conf /etc/apache2/sites-available/$apache_config
# set sitekey, sitedomain, and escape domain in apache config
sudo sed -i "s/!!KEY!!/$sitekey/g" /etc/apache2/sites-available/$apache_config
sudo sed -i "s/!!DOMAIN!!/$sitedomain/g" /etc/apache2/sites-available/$apache_config
sudo sed -i "s/!!ESCAPEDOMAIN!!/$escapedomain/g" /etc/apache2/sites-available/$apache_config
# enable site
sudo a2ensite $apache_config
# reload apache
sudo systemctl reload apache2

# - - - - - ENABLE SSL CERTIFICATE - - - - -
# run certbot
sudo certbot --apache -d www.$sitedomain -d $sitedomain -v
# reload apache
sudo systemctl reload apache2
