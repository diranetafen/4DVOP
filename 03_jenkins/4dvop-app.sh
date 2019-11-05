#!/bin/bash

# This script was written to deploy 4dvop-app
# This script is compatible with centos OS

### Install and configure NGINX
sudo yum -y update && sudo yum -y install epel-release && sudo yum -y install nginx git
sudo rm -Rf /usr/share/nginx/html/*
sudo git clone https://github.com/diranetafen/static-website-example.git /usr/share/nginx/html/
sudo sed -i 's/80 default_server/8080 default_server/g' /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo systemctl enable nginx

### Install and configure haproxy
sudo yum install -y haproxy

sudo tee /etc/haproxy/haproxy.cfg > /dev/null <<EOT
global
  #debug                                   # uncomment to enable debug mode for HAProxy

defaults
  mode http                                # enable http mode which gives of layer 7 filtering
  timeout connect 5000ms                   # max time to wait for a connection attempt to a server to succeed
  timeout client 50000ms                   # max inactivity time on the client side
  timeout server 50000ms                   # max inactivity time on the server side

backend nginx                              # define a group of backend servers to handle legacy requests
  server nginx_server 127.0.0.1:8080           # add a server to this backend

frontend haproxy                           # define what port to listed to for HAProxy
  bind *:80
  default_backend nginx                    # set the default server for all request
EOT

sudo systemctl restart haproxy
sudo systemctl enable haproxy

### Open http port
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload
