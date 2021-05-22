#!/usr/bin/env bash

# Take old VPN connection down
echo "Taking down VPN tunnel...."
sudo systemctl stop openvpn-client@bashvpn
sudo killall openvpn

# Stop sytemd-resolve and NetworkManager
echo "Taking down NetworkManager and resolved..."
sudo systemctl stop NetworkManager
sudo systemctl stop systemd-resolved

# Reset resolv.conf to be managed by systemd-resolve
echo "Restoring resolv.conf..."
# chattr will result in "Operation not supported while reading flags” if the file is a symlink
if ! [[ -L /etc/resolv.conf ]]; then
	sudo chattr -i /etc/resolv.conf
fi
sudo chmod 744 /etc/resolv.conf
sudo rm /etc/resolv.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Remove firewall restrictions
echo "Resetting firewall..."
source ./iptables_accept_all.sh

# Bring connection back up
echo "Taking up connection..."
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
