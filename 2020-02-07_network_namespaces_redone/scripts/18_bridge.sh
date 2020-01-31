#!/bin/bash

set -xe

brctl addbr br0
brctl addif br0 blue0out
brctl addif br0 red0out

ip link set br0 up
