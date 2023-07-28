First version of the `server-create` Bash script.

Creates all necessary parts of a new Wordpress site on a multisite LAMP-stack server.

Disclaimer for people that happened to stumble on this script: This script is heavily hardcoded for use on a specific server with its own particular process. It's expecting an Ubuntu server with specific packages preinstalled and preconfigured, existing configurations for Apache, MySQL, etc., and certain website template files that aren't currently packaged with this repo for server disk space reasons.

# Installation
Copy `server-create.sh` to `/usr/bin/server-create` and set it to executable with `chmod 755 /usr/bin/server-create.sh`. It should now be executable from anywhere as `server-create`.

To use the script, enter the command and follow the prompts as directed.