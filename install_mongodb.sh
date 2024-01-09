#!/bin/bash
#mongodb install script
sudo apt update
sudo apt install mongodb -y
sudo systemctl start mongodb
sudo systemctl enable mongodb
