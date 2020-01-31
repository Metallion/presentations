#!/bin/bash

set -xe

ip netns add red

ip link add red0out type veth peer red0in
ip link set red0in netns red

ip netns exec red ip link set red0in up
ip netns exec red ip addr add 10.0.0.11/24 dev red0in

ip link set red0out up
