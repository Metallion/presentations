#!/bin/bash
set -ue

cd /home/edison/openvnet/vnet

bundle exec ./bin/vnmgr >> /var/log/openvnet/vnmgr.log 2>&1 &
echo $! > vnmgr.pid

bundle exec unicorn -o 0.0.0.0 -p 9090 ./rack/config-webapi.ru >> /var/log/openvnet/webapi.log 2>&1 &
echo $! > webapi.pid

bundle exec ./bin/vna >> /var/log/openvnet/vna.log 2>&1 &
echo $! > vna.pid
