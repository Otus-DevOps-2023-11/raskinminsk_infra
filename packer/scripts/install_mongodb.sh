#!/bin/bash
#mongodb install script
apt-get update
sleep 30
apt-get install mongodb -y
sleep 30
systemctl start mongodb
sleep 30
systemctl enable mongodb
