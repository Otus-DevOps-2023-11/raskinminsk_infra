#!/bin/bash
#git install
sudo apt update
sudo apt install git -y
#monolith-application install
cd ~/
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma –d
