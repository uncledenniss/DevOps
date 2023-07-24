# Step 1:

```
Update the 'apt' package manager & Install nginx 

sudo apt update

sudo apt install nginx

sudo systemctl status nginx
```

```bash
sudo mysql
```
Use the command `sudo mysql` to start MySQL.


# Step 2: — INSTALL MYSQL


```

sudo apt install mysql-server
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1';
mysql> exit
sudo mysql_secure_installation

```

# STEP 3 – INSTALL PHP

```
sudo apt install php-fpm php-mysql
php -v

```


# STEP 4 — CONFIGURING NGINX TO USE PHP PROCESSOR

```
sudo mkdir /var/www/projectLEMP
sudo chown -R $USER:$USER /var/www/projectLEMP
sudo nano /etc/nginx/sites-available/projectLEMP
```

```
#/etc/nginx/sites-available/projectLEMP

server {
   listen 80;
   server_name projectLEMP www.projectLEMP;
   root /var/www/projectLEMP;

   index index.html index.htm index.php;

   location / {
       try_files $uri $uri/ =404;
   }

   location ~ \.php$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
   }

   location ~ /\.ht {
      deny all;
   }

 }
```


```
sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/
sudo nginx -t
sudo unlink /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
sudo echo 'Hello LEMP from hostname' $(curl -s http://localhost/latest/meta-data/public-hostname) 'with public IP' $(curl -s http://localhost/latest/meta-data/public-ipv4) > /var/www/projectLEMP/index.html
```


# STEP 5 – TESTING PHP WITH NGINX

```

sudo nano /var/www/projectLEMP/info.php

<?php
phpinfo();

sudo rm /var/www/hostip/info.php

```

# STEP 6 – RETRIEVING DATA FROM MYSQL DATABASE WITH PHP

```

sudo mysql -p
mysql> CREATE DATABASE `example_database`;    
mysql>  CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY '***********';
mysql> GRANT ALL ON example_database.* TO 'example_user'@'%';
mysql> exit
mysql -u example_user -p    
mysql> SHOW DATABASES;    

CREATE TABLE example_database.todo_list (
   item_id INT AUTO_INCREMENT,
   content VARCHAR(255),
   PRIMARY KEY(item_id)
);

mysql> INSERT INTO example_database.todo_list (content) VALUES
                  ("My first important item"),
                  ("My second important item"),
                  ("My third important item");



mysql>  SELECT * FROM example_database.todo_list;
nano /var/www/projectLEMP/todo_list.php




 <?php
 $user = "example_user";
 $password = "**********";
 $database = "example_database";
 $table = "todo_list";

 try {
   $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
   echo "<h2>TODO</h2><ol>";
   foreach($db->query("SELECT content FROM $table") as $row) {
     echo "<li>" . $row['content'] . "</li>";
   }
   echo "</ol>";
 } catch (PDOException $e) {
     print "Error!: " . $e->getMessage() . "<br/>";
     die();
 }

```


### LINK TO  ![IMAGE FOLDER](../images/Project-1-LAMP-STACK)



