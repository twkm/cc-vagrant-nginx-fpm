#!/bin/bash

# Starts the MySQL and Apache services
# Shows the MySQL Initial root password
# Apache needs to be started with this provision script to allow vagrant to sync our folder first which contains the apache configuration file for our project

service php7.1-fpm restart
service nginx restart
