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

vnctl networks add --uuid nw-test1 --display-name testnet1 --ipv4-network 172.16.0.0 --ipv4-prefix 24 --network-mode virtual
vnctl networks add --uuid nw-test2 --display-name testnet1 --ipv4-network 192.168.100.0 --ipv4-prefix 24 --network-mode virtual

vnctl interfaces add --uuid if-inst1 --mode vif --owner-datapath-uuid dp-test1 --mac-address 10:54:ff:00:00:01 --network-uuid nw-test1 --ipv4-address 172.16.0.10 --port-name inst1
vnctl interfaces add --uuid if-inst2 --mode vif --owner-datapath-uuid dp-test1 --mac-address 10:54:ff:00:00:02 --network-uuid nw-test2 --ipv4-address 192.168.100.10 --port-name inst2

# Add DHCP servers

vnctl interfaces add --uuid if-dhcp1 --mode simulated --owner-datapath-uuid dp-test1 --mac-address 02:00:00:00:01:11 --network-uuid nw-test1 --ipv4-address 172.16.0.100
vnctl interfaces add --uuid if-dhcp2 --mode simulated --owner-datapath-uuid dp-test1 --mac-address 02:00:00:00:01:12 --network-uuid nw-test2 --ipv4-address 192.168.100.100

vnctl network-services add --uuid ns-dhcp1 --interface-uuid if-dhcp1 --type dhcp
vnctl network-services add --uuid ns-dhcp2 --interface-uuid if-dhcp2 --type dhcp

# Add routers

vnctl interfaces add --uuid if-router1 --network_uuid nw-test1 --mac_address "02:00:00:00:02:01" --ipv4_address 172.16.0.1 --mode simulated --enable_routing true
vnctl interfaces add --uuid if-router2 --network_uuid nw-test2 --mac_address "02:00:00:00:02:02" --ipv4_address 192.168.100.1 --mode simulated --enable_routing true

vnctl network_services add --uuid ns-router1 --interface_uuid if-router1 --type router
vnctl network_services add --uuid ns-router2 --interface_uuid if-router2 --type router

vnctl route_links add --uuid rl-1 --mac-address 02:00:10:00:00:01

vnctl routes add --uuid r-1 --interface-uuid if-router1 --network-uuid nw-test1 --ipv4-network 172.16.0.0 --route-link-uuid rl-1
vnctl routes add --uuid r-2 --interface-uuid if-router2 --network-uuid nw-test2 --ipv4-network 192.168.100.100 --route-link-uuid rl-1
