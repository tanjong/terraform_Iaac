#!/bin/bash
sudo apt update -y 
sudo apt install apache2 -y --quiet
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "Welcome to my Apache webserver" > /var/www/html/index.html
sudo systemctl restart apache2 