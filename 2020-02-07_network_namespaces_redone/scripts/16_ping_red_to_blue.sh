#!/bin/bash

set -xe

ip netns exec red ping 10.0.0.10
