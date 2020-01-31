#!/bin/bash

set -xe

ip netns exec blue ip link set blue0in up
ip netns exec blue ip addr add 10.0.0.10/24 dev blue0in

ip link set blue0out up
ip addr add 10.0.0.1/24 dev blue0out
