#!/usr/bin/env bash

# Check that the script is called with just one command line option
# (the ovpn configuration file)
if [ $# -ne 1 ]; then
	echo "ERROR: call this script with the path to the .ovpn configuration file as first argument"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "OVPN configuration file $1 not found"
	exit 1
fi

# Get IP address of the VPN server
remote=`grep -Po '(?<=remote\s).*' $1`
remoteip=`echo $remote | grep -Po ".*(?=\s)"`
remoteport=`echo $remote | grep -Po "(?<=\s).*"`
proto=`grep -Po '(?<=proto\s).*' $1`
echo "[DEBUG] IP address of VPN server is: $remoteip ($remoteport/$proto)"

# Get VPN DNS servers from config file
dns1=`grep -Po "(?<=DNS1=).*" config.ini`
dns2=`grep -Po "(?<=DNS2=).*" config.ini`

# Flush out current rules
sudo iptables -F && sudo iptables -X
sudo ip6tables -F && sudo ip6tables -X

# Import new rules

# ** IP4 ** #

# Drop all packets
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Allow incoming packets only for related and established connections
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow loopback and tunnel interface
sudo iptables -A OUTPUT -o lo -j ACCEPT
sudo iptables -A OUTPUT -o tun0 -p icmp -j ACCEPT

# Allow local LAN
sudo iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT

# Allow localhost (make software like RStudio works)
sudo iptables -A INPUT -s 127.0.0.1/8 -d 127.0.0.1/8 -j ACCEPT

# Allow VPN DNS servers
sudo iptables -A OUTPUT -d $dns1 -j ACCEPT
sudo iptables -A OUTPUT -d $dns2 -j ACCEPT

# Allow connections to the VPN server
sudo iptables -A OUTPUT -p $proto -m $proto --dport $remoteport -d $remoteip -j ACCEPT

# Allow the VPN tunnel interface
sudo iptables -A OUTPUT -o tun0 -j ACCEPT

# ** IP6 ** #

sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT DROP

# Make rules persistent (require iptables-persistent to be installed)
ip4tables_file=`grep -Po "(?<=IP4TABLES_FILE=).*" config.ini`
echo "[DEBUG] [KILLSWITCH] ip4tables_file=$ip4tables_file"
ip6tables_file=`grep -Po "(?<=IP6TABLES_FILE=).*" config.ini`
echo "[DEBUG] [KILLSWITCH] ip6tables_file=$ip6tables_file"
sudo iptables-save | sudo tee $ip4tables_file > /dev/null
sudo ip6tables-save | sudo tee $ip6tables_file > /dev/null
