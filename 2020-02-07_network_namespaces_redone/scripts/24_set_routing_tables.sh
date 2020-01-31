#!/bin/bash

set -xe

ip netns exec blue ip route add default via 10.0.0.1
ip netns exec red ip route add default via 10.0.0.1
