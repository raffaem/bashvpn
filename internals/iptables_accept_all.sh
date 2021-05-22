#!/usr/bin/env bash

# ** IP4 ** #
# flush all chains
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F

# delete all chains
sudo iptables -X

# accept all
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT

# ** IP6 ** #
# flush all chains
sudo ip6tables -F
sudo ip6tables -t nat -F
sudo ip6tables -t mangle -F

# delete all chains
sudo ip6tables -X

# accept all
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P OUTPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
