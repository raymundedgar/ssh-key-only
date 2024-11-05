#!/bin/bash

# Backup the sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Disable password authentication
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Enable public key authentication (if not already enabled)
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Restart the SSH service to apply changes
sudo systemctl restart ssh
