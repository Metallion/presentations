#!/bin/bash

set -xe

ip netns add bottom-left
ip link add bottom-left-in type veth peer bottom-left-out
ip link set bottom-left-in netns bottom-left
sudo ip netns exec bottom-left ip link set bottom-left-in up
sudo ip netns exec bottom-left ip addr add 10.0.0.10/24 dev bottom-left-in

ip netns add bottom-right
ip link add bottom-right-in type veth peer bottom-right-ot
ip link set bottom-right-in netns bottom-right
sudo ip netns exec bottom-right ip link set bottom-right-in up
sudo ip netns exec bottom-right ip addr add 10.0.0.11/24 dev bottom-right-in

brctl addbr bottom-middle
ip link set bottom-middle up
ip link set bottom-left-out up
ip link set bottom-right-ot up
brctl addif bottom-middle bottom-left-out
brctl addif bottom-middle bottom-right-ot
