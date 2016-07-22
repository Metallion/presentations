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

vnctl datapaths add --uuid dp-eddy1 --display-name eddy1 --dpid 0x0000000ec6c2fbde --node-id eddy1-vna

vnctl networks add --uuid nw-test1 --display-name testnet1 --ipv4-network 10.100.0.0 --ipv4-prefix 24 --network-mode virtual

vnctl interfaces add --uuid if-randy --mode vif --owner-datapath-uuid dp-eddy1 --mac-address b8:27:eb:6a:cc:80 --network-uuid nw-test1 --ipv4-address 10.100.0.10 --port-name enp0s17u1u3
vnctl interfaces add --uuid if-pete  --mode vif --owner-datapath-uuid dp-eddy1 --mac-address b8:27:eb:5b:21:ba --network-uuid nw-test1 --ipv4-address 10.100.0.11 --port-name enp0s17u1u2
