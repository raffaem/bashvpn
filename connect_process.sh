#!/usr/bin/env bash

if [ $# -ne 1 ]; then
	echo "ERROR: call this script with the path to the .ovpn configuration file as first argument"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "OVPN configuration file $1 not found"
	exit 1
fi

# Restore "VPN mode"
source ./internals/vpnmode_do.sh $1

# Wait for connection to be restored
sleep 5

# Connect to the VPN
sudo openvpn $1
