#!/bin/bash

# Get all ip address
terra_ip_out=`cd ../terraform/stage; terraform output`
echo
echo $terra_ip_out
echo

# Get app ip address
app_ip_out=`echo $terra_ip_out | grep external_ip_address_app | awk '{print $3}'`
echo "external app address: $app_ip_out"

# Get db ip address
db_ip_out=`echo $terra_ip_out | grep external_ip_address_db | awk '{print $6}'`
echo "external db address: $db_ip_out"
echo

# Put app and db addresses to json inventory file
#echo -e "{\"app\": {\"hosts\": [$app_ip_out]}, \"db\": {\"hosts\": [$db_ip_out]}}" | python -m json.tool > inventory.json
echo -e "{\"app\": {\"hosts\": {\"appserver\": {\"ansible_host\": $app_ip_out}}}, \"db\": {\"hosts\": {\"dbserver\": {\"ansible_host\": $db_ip_out}}}}" \
| python -m json.tool > ~/raskinminsk_infra/ansible/inventory.json
