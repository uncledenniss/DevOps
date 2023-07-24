
# Step 1: Apache Install

In this step I created an Ubuntu instance Azure and I connected with PowerShell via password and
username. You can see how to here: ![Azure Vm](https://learn.microsoft.com/en-us/azure/virtual-machines/linux-vm-connect?tabs=Windows#password-authentication-1)

I ran the following cmd to install Apache on the ubuntu

```

sudo apt update
sudo apt install apache2
sudo systemctl status apache2 
curl -s http://74.235.184.124/meta-data/public-ipv4

```

# Step 2: MySql Install

```
sudo apt install mysql-server
sudo mysql
sudo mysql_secure_installation
sudo mysql -p

```

# STEP 3: Installing PHP

```

sudo apt install php libapache2-mod-php php-mysql
php -v

```

# STEP 4: Create a Virtual Host

```

sudo mkdir /var/www/projectlamp
sudo chown -R $USER:$USER /var/www/projectlamp

sudo vi /etc/apache2/sites-available/projectlamp.conf
 <VirtualHost *:80>
 ServerName projectlamp
 ServerAlias www.projectlamp
 ServerAdmin webmaster@localhost
 DocumentRoot /var/www/projectlamp
 ErrorLog ${APACHE_LOG_DIR}/error.log
 CustomLog ${APACHE_LOG_DIR}/access.log combined
 </VirtualHost>
 sudo ls /etc/apache2/sites-available
sudo a2ensite projectlamp
 sudo a2dissite 000-default
 sudo apache2ctl configtest
 sudo systemctl reload apache2
sudo echo 'Hello LAMP from hostname' $(curl -s http://localhost/latest/meta-data/public-hostname)
'with public IP' $(curl -s http://localhost/latest/meta-data/public-ipv4) >
/var/www/projectlamp/index.html
input http://<Public-IP-Address>:80 on a browser to see the output

```

# Step 5 Enable PHP on Website

```

sudo vim /etc/apache2/mods-enabled/dir.conf
<IfModule mod_dir.c>
 #Change this:
 #DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
 #To this:
 DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
sudo systemctl reload apache2
run : vim /var/www/projectlamp/index.php
<?php
phpinfo();
Goto page on browser http://<public ip> and see how it display the php page
sudo rm /var/www/projectlamp/index.php


```


### LINK TO  ![IMAGE FOLDER](../Images/Project-1-LAMP-STACK)
