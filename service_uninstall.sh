#!/usr/bin/env bash

# Stop the service in case it is running
sudo systemctl stop openvpn-client@bashvpn
sudo killall openvpn

# Remove configuration file
sudo rm /etc/openvpn/client/bashvpn.conf

# Undo VPN mode
source ./internals/vpnmode_undo.sh

echo "The OpenVPN service has been uninstalled"

