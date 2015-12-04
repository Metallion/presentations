#!/bin/bash
set -ue

PATH=/opt/axsh/openvnet/ruby/bin:${PATH}

sudo stop vnet-vna
sudo stop vnet-webapi
sudo stop vnet-vnmgr

cd /opt/axsh/openvnet/vnet
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:init

sudo start vnet-vnmgr
sudo start vnet-webapi
sudo start vnet-vna

sleep 2

vnctl datapaths add --uuid dp-test1 --display-name test1 --dpid 0x0000aaaaaaaaaaaa --node-id vna

vnctl networks add --uuid nw-test1 --display-name testnet1 --ipv4-network 10.100.0.0 --ipv4-prefix 24 --network-mode virtual

vnctl interfaces add --uuid if-inst1 --mode vif --owner-datapath-uuid dp-test1 --mac-address 10:54:ff:00:00:01 --network-uuid nw-test1 --ipv4-address 10.100.0.10 --port-name inst1
vnctl interfaces add --uuid if-inst2 --mode vif --owner-datapath-uuid dp-test1 --mac-address 10:54:ff:00:00:02 --network-uuid nw-test1 --ipv4-address 10.100.0.11 --port-name inst2
