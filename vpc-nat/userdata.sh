#!/bin/bash -v
echo "userdata-start"
sudo apt-get update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
echo "userdata-end"
echo ${ssh_private_key} | sudo tee /home/ubuntu/key.txt
chmod 600 /home/ubuntu/key.txt