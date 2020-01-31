#!/bin/bash

set -xe

ip netns exec blue ping 8.8.8.8
