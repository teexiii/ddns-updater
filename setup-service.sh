#!/bin/bash

# Create service file content
SERVICE_CONTENT="[Unit]
Description=Your Startup Script
After=network.target

[Service]
Type=simple
WorkingDirectory=/root/projects/ddns-updater
ExecStart=/root/projects/ddns-updater/change-dns.sh
User=root

[Install]
WantedBy=multi-user.target"

# Write service file
echo "$SERVICE_CONTENT" | sudo tee /etc/systemd/system/change-dns.service

# Set correct permissions
sudo chmod 644 /etc/systemd/system/change-dns.service

# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable change-dns.service
sudo systemctl start change-dns.service

echo "Service has been created and started successfully"
