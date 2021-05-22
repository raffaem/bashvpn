#!/usr/bin/env bash

# Remove old resolv.conf
sudo chattr -i /etc/resolv.conf
sudo chmod 744 /etc/resolv.conf
sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf

# Get VPN DNS servers from config file
dns1=`grep -Po "(?<=DNS1=).*" config.ini`
dns2=`grep -Po "(?<=DNS2=).*" config.ini`
echo "[DEBUG] DNS1=$dns1; DNS2=$dns2"

# Write new resolv.conf with VPN's DNS servers
echo "# VPN DNS servers" | sudo tee -a /etc/resolv.conf > /dev/null
echo "nameserver $dns1" | sudo tee -a /etc/resolv.conf > /dev/null
echo "nameserver $dns2" | sudo tee -a /etc/resolv.conf > /dev/null

# Make new resolv.conf immutable
sudo chmod 444 /etc/resolv.conf
sudo chattr +i /etc/resolv.conf
