#!/bin/sh

IN_FACE="wlp6s0"                   # NIC connected to the internet
SUB_NET="192.168.10.1/24"          # IPv4 sub/net aka CIDR
TAP_FACE=tap0

# cleanup, delete tap interface
ip addr flush dev $TAP_FACE
ip link set dev $TAP_FACE down
ip tuntap del mode tap dev $TAP_FACE


iptables -t nat -D POSTROUTING -o $IN_FACE -j MASQUERADE
iptables -D FORWARD -i $TAP_FACE -o $IN_FACE -j ACCEPT
iptables -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
