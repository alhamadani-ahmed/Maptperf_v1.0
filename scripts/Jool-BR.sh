#!/bin/bash

ip link set eno1 up
ip address add 2001:db8:6::1/64 dev eno1

ip link set eno2 up
ip address add 203.0.113.1/24 dev eno2

ip route add 2001:db8:ce::/51 dev eno1

sysctl -w net.ipv4.conf.all.forwarding=1
sysctl -w net.ipv6.conf.all.forwarding=1

#JOOL BR
/sbin/modprobe jool_mapt
jool_mapt instance add "BR" --netfilter --dmr 64:ff9b::/96
jool_mapt -i "BR" fmrt add 2001:db8:ce::/51 192.0.2.0/24 13 0
jool_mapt -i "BR" global update map-t-type BR


