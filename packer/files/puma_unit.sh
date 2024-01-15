cat <<EOF | sudo tee /etc/systemd/system/puma.service > /dev/null
[Unit]
Description=Puma
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/ubuntu/reddit/
ExecStart=/usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Activate puma unit
sudo systemctl start puma
sudo systemctl enable puma
