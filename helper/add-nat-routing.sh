#!/bin/sh

IN_FACE="wlp6s0"                   # NIC connected to the internet
SUB_NET="192.168.10.1/24"          # IPv4 sub/net aka CIDR
TAP_FACE=tap0

# create tap interface which will be connected to OpenWrt LAN NIC
ip tuntap add dev $TAP_FACE mode tap user $(whoami)
ip link set $TAP_FACE up

# iptables rules
iptables -t nat -A POSTROUTING -o $IN_FACE -j MASQUERADE
iptables -A FORWARD -i $TAP_FACE -o $IN_FACE -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# configure interface with static ip to avoid overlapping routes
ip addr add $SUB_NET dev $TAP_FACE