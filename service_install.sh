#!/usr/bin/env bash

if [ $# -ne 1 ]; then
	echo "ERROR: call this script with the path to the .ovpn configuration file as first argument"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "OVPN configuration file $1 not found"
	exit 1
fi

# Set up DNS servers and killswitch
source ./internals/vpnmode_do.sh

# Copy the .ovpn configuration file to OpenVPN folder
openvpn_conf_dir=`grep -Po "(?<=OPENVPN_CONF_DIR=).*" config.ini`
sudo cp $1 $openvpn_conf_dir/bashvpn.conf

# Enable the service
sudo systemctl enable openvpn-client@bashvpn
sudo systemctl start openvpn-client@bashvpn

echo "The OpenVPN service has been installed and should be running"

