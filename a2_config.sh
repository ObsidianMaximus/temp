echo "<VirtualHost *:80>                                  # Make a config file for apache2 and add the following stuff into it.               
    DocumentRoot "/var/www/nextcloud"
    ServerName 10.0.2.15

    <Directory "/var/www/nextcloud/">
        Options MultiViews FollowSymlinks
        AllowOverride All
        Order allow,deny
        Allow from all
   </Directory>

   TransferLog /var/log/apache2/nextcloud_access.log
   ErrorLog /var/log/apache2/nextcloud_error.log

</VirtualHost>" | sudo tee /etc/apache2/sites-available/nextcloud.conf
