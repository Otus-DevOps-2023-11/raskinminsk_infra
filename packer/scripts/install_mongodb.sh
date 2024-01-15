#!/bin/bash
#mongodb install script
apt-get install mongodb -y
sleep 10
systemctl start mongodb
systemctl enable mongodb
