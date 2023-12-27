# raskinminsk_infra
raskinminsk Infra repository

# How to make "ssh someinternalhost"

# Step 1 - add to ~/.bashrc two lines:
# eval $(ssh-agent -s)
# ssh-add ~/.ssh/appuser

# Step 2 :
# touch ~/.ssh/config
# nano ~/.ssh/config
# Then add four lines:
# Host bastion
#     Hostname 178.154.202.169
#     user appuser
#     ForwardAgent yes

bastion_IP = 178.154.202.169
someinternalhost_IP = 10.128.0.13

# How to configure openvpn client on local host
# Download profile file "test.tar" for user "test" from "Users and Organizations" Pritunl web-page on VM bastion
# On local host:
# sudo apt install openvpn
# tar xvf test.tar
# sudo mv test_test_bastionvpn.ovpn /etc/openvpn/client.conf
# sudo chown root:root /etc/openvpn/client.conf

# sudo nano /etc/openvpn/auth.txt              - autostart openvpn client with username and PIN
# Add two lines, user and PIN:
# test
# 6214157507237678334670591556762

# sudo openvpn --client --config /etc/openvpn/client.conf &
# sudo systemctl enable openvpn@client.service
# sudo service openvpn@client start

# Checking status openvpn client on local host:
# curl ifconfig.me - show external IP
# ip a  	   - vpn tunnel "tun0" is present
# ssh -i ~/.ssh/appuser appuser@10.128.0.13    - ssh connect to VM "someinternalhost"
# LOGs on Pritunl VM "bastion"
