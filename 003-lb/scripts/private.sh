#!/bin/bash

yum update -y

yum install -y nginx

systemctl start nginx

echo "<h1><center>Private</center></h1>" > /usr/share/nginx/html/index.html
echo "<h1><center>$(hostname)</center></h1>" >> /usr/share/nginx/html/index.html