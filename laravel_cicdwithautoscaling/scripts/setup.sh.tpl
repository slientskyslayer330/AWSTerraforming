#!/bin/bash
yum update -y
yum install -y ruby wget curl zip unzip
yum install -y amazon-linux-extras
amazon-linux-extras enable php8.1
yum clean metadata
amazon-linux-extras install -y php8.1
yum install -y php-mbstring php-xml php-gd php-zip php-bcmath php-pgsql php-posix php-sodium
yum remove -y httpd
amazon-linux-extras install -y nginx1
amazon-linux-extras install -y epel

wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x install
./install auto

aws s3 cp s3://${s3_bucket}/production.nginx.conf /etc/nginx/nginx.conf
aws s3 cp s3://${s3_bucket}/php-fpm.conf /etc/php-fpm.d/www.conf 

systemctl enable nginx
systemctl enable php-fpm

systemctl start nginx
systemctl start php-fpm

usermod -a -G apache ec2-user
