#!/bin/bash

set -xe

ip link add blue0out type veth peer blue0in
