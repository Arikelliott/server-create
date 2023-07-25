#! /bin/bash

program_name="server-create.sh"
version=v0.0.1
config="/usr/local/etc/server-create/server-create.conf"


# Structure:
    # warning about dangers of using script
    # mention location of config file
    # ask for sitekey name
    # ask for mysql root password

    # make html website folder, then public_html folder
    # make mysql database for website, then website user/password. grant privileges to user for database.
    # copy wordpress template files to website folder. modify wp-config.php for sitekey.
    # copy initdb.sql, modify for sitekey. add to mysql database.
    # copy apache template, modify for sitekey. run sitekey config. reload apache.






# Variables:
#     config location
#     html folder (/var/www/html) c
#     sitekey u
#     root password u
#     template location c
#     initdb.sql location c
#     apache folder (/etc/apache2/sites-available) c
#     apache template c
#     sitedomain u
#     siteescapedomain u



# - - - - - ACTUAL SCRIPT STARTS HERE!!! - - - - -

# - - - - - INITIAL - - - - -
echo -e "Using ${program_name}, version ${version}."
echo -e "\033[31mCAUTION! This script requires sudo privileges; mistyped file paths, etc. may cause file loss and other problems!\033[0m"
echo ""
echo "Using default configuration file. Config is located at $config"
echo ""

# - - - - - SITEKEY AND MYSQL PASSWORD - - - - -
# read sitekey
echo -e "Enter website name to create (example: \"yourwebsite.com\")"
read sitekey_raw
# make sure sitekey has no ".com" at the end but sitedomain does
sitekey=$(echo ${sitekey_raw} | sed "s/.com//g")
sitedomain=$sitekey".com"
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
mysql_database_password="${sitekey}pw1"
# create mysql database
mysql_makedb="CREATE DATABASE IF NOT EXISTS $mysql_database; CREATE USER '$mysql_database_user' IDENTIFIED BY 'mysql_database_password'; GRANT ALL PRIVILEGES ON ${mysql_database}.* TO '$mysql_database_user'; FLUSH PRIVILEGES;"
sudo mysql --user="$mysql_root_user" --password="$mysql_root_password" --execute="$mysql_makedb"

# - - - - - WORDPRESS FILES - - - - -
# html root directory (typically /var/www/html)
html_root="/var/www/html"
# create sitekey folders
sudo mkdir -p $html_root/$sitekey/public_html
# copy template files to new wordpress directory
sudo cp -r $html_root/TEMPLATE/wordpress/* $html_root/$sitekey/public_html
# modify wp-config.php to include sitekey
sudo sed -i 's/!!KEY!!/sitekey/g' $html_root/$sitekey/public_html/wp-config.php

# - - -

# unset mysql password (PLACE AFTER ALL MYSQL COMMANDS)
unset mysql_root_dbpassword