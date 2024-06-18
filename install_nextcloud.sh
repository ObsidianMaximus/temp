sudo apt update && sudo apt dist-upgrade

sudo apt install libmagickcore-6.q16-6-extra php php-apcu php-bcmath php-cli php-common php-curl php-gd php-gmp php-imagick php-intl php-mbstring php-mysql php-zip php-xml apache2 mariadb-server unzip -y         # This installs apache2 and php. Check if apache2 is running via systemctl.

wget https://download.nextcloud.com/server/releases/latest.zip

unzip latest.zip

sudo phpenmod imagick intl bcmath gmp       # Enable these modules, so php can use them, as needed.

sudo chown www-data:www-data -R nextcloud

sudo mv nextcloud /var/www/

sudo a2dissite 000-default.conf                         # Disable apache2 default site. 

#This below command can ask for time pass stuff.

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -nodes

# Add this in the /var/www/nextcloud/config/config.php file to fix error ' Host 10.0.2.15 was not connected to because it violates local access rules '

# 'allow_local_remote_servers' => true,

# sudo mysql_secure_installation                                # Do this to increase security. The default root password is none at first time, so just press enter. Then next, unix_socket must be n.
                                                              # Change the root password. And then y to everything else.
                                                              # 374kibo

# sudo mariadb                                                  # Opens mariadb shell. Add the following stuff in it: 
                                                              # 1) CREATE DATABASE nextcloud;   # To verify that the database has been created, type 'SHOW DATABASES;'
                                                              # 2) GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY 'Your_Pass'; # This grants privileges to a new user nextcloud and sets a password for the db. 
                                                              # 3) FLUSH PRIVILEGES;
                                                              # 4) exit;

echo "<VirtualHost *:80>

    RewriteEngine On
    RewriteCond %{SERVER_PORT} !443
    RewriteRule ^(/(.*))?$ https://%{HTTP_HOST}/$1 [R=301,L]

</VirtualHost>

<VirtualHost *:443>                                  # Make a config file for apache2 and add the following stuff into it.               
    DocumentRoot /var/www/nextcloud

	SSLCertificateFile $HOME/cert.pem
	SSLCertificateKeyFile $HOME/key.pem
	SSLEngine on


    <Directory /var/www/nextcloud/>
        Options MultiViews FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
   </Directory>

   TransferLog /var/log/apache2/nextcloud_access.log
   ErrorLog /var/log/apache2/nextcloud_error.log

<IfModule mod_headers.c>
    Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
</IfModule>
</VirtualHost>" | sudo tee /etc/apache2/sites-available/nextcloud.conf


sudo a2ensite nextcloud.conf

sudo a2enmod dir env headers mime rewrite ssl           # Modules required by apache3, so enable them for use with nextcloud.

echo "apc.enable_cli=1" | sudo tee -a /etc/php/8.1/mods-available/apcu.ini      # Enable the apcu module in php. This module caches data in memory, so helps in reducing database queries and file system operations. This also allows the occ script to function.

sudo systemctl restart apache2

sudo nvim /var/www/nc.krishnayadav.xyz/config/config.php            # Add the following 2 lines(The commas are required!): 'memcache.local' => '\\OC\\Memcache\\APCu',
                                                                    #                                                      'default_phone_region' => 'IN',