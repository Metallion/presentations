#!/bin/bash

set -xe

iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE

ip netns exec blue ip route add default via 10.0.0.1
ip netns exec red ip route add default via 10.0.0.1
