#!/bin/bash

set -xe

systemctl stop docker
iptables -F
iptables -t nat -F
iptables -P FORWARD ACCEPT

brctl show | tail -n +2 | while read line; do
  bridge="$(echo $line | cut -d ' ' -f1)"
  ip link set $bridge down
  brctl delbr $bridge
done;
