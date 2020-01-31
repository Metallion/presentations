#!/bin/bash

set -xe

ip addr del 10.0.0.1/24 dev blue0out
ip addr add 10.0.0.1/24 dev br0
