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



# ACTUAL SCRIPT STARTS HERE!!!

# INITIAL
echo -e "Using ${program_name}, version ${version}."
echo -e "\033[31mCAUTION! This script requires sudo privileges; mistyped file paths, etc. may cause file loss and other problems!\033[0m"
echo ""
echo "Using default configuration file. Config is located at $config"
echo ""

# SITEKEY AND MYSQL PASSWORD
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
read -s root_dbpassword
echo "Entered!"

