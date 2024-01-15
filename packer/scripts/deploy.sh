#!/bin/bash

# Install git
sudo apt-get update
sleep 10
sudo apt-get install git -y
sleep 10

#monolith-application install
cd ~/
git clone -b monolith https://github.com/express42/reddit.git
sleep 10

# Install bundle
cd reddit && bundle install
sleep 10

#Start server puma
puma -d
sleep 10
