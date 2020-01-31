#!/bin/bash

set -xe

iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
