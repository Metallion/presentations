#!/bin/bash

set -xe

#ip netns exec blue ip link set blue0in down
#ip link set blue0out down
#ip link del blue0out

#ip netns exec red ip link set red0in down
#ip link set red0out down
#ip link del red0out

#ip netns del blue
#ip netns del red

#iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -j MASQUERADE

ip link set br0 down
brctl delbr br0
