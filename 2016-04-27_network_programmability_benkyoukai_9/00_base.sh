#!/bin/bash
set -ue

PATH=/opt/axsh/openvnet/ruby/bin:${PATH}

cat <<EOS
*****************************************
* Configuring OpenVNet physical network *
*****************************************
EOS

sudo stop vnet-vna
sudo stop vnet-webapi
sudo stop vnet-vnmgr

ssh itest2 "stop vnet-vna"
ssh itest3 "stop vnet-vna"

cd /opt/axsh/openvnet/vnet
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:init

sudo start vnet-vnmgr
sudo start vnet-webapi

# Wait for the webapi to come online
while [[ ! $(nc -z localhost 9090) ]]; do
  sleep 2
done;

vnctl datapaths add --uuid dp-1 --display-name node1 --dpid 0x0000aaaaaaaaaaaa --node-id vna1
vnctl datapaths add --uuid dp-2 --display-name node2 --dpid 0x0000bbbbbbbbbbbb --node-id vna2
vnctl datapaths add --uuid dp-3 --display-name node3 --dpid 0x0000cccccccccccc --node-id vna3

sudo start vnet-vna
ssh itest2 "start vnet-vna"
ssh itest3 "start vnet-vna"

vnctl networks add --uuid "nw-public1" --display_name "public1" --ipv4_network "172.16.90.0" --ipv4_prefix "24" --domain_name "public" --network_mode "physical"

vnctl networks add --uuid "nw-public2" --display_name "public2" --ipv4_network "172.16.91.0" --ipv4_prefix "24" --domain_name "public" --network_mode "physical"

vnctl mac_range_groups add --uuid "mrg-dpg"
vnctl mac_range_groups mac_ranges add mrg-dpg --begin_mac_address "08:00:27:aa:00:00" --end_mac_address "08:00:27:aa:ff:ff"

vnctl topologies add --uuid "topo-physical" --mode "simple_underlay"
vnctl topologies add --uuid "topo-vnet" --mode "simple_overlay"
vnctl topologies networks add topo-physical "nw-public1"
vnctl topologies networks add topo-physical "nw-public2"

vnctl interfaces add --uuid "if-dp1eth0" --mode "host" --port_name "eth0" --owner_datapath_uuid "dp-1" --network_uuid "nw-public1" --mac_address "02:01:00:00:00:01" --ipv4_address "172.16.90.10"
vnctl interfaces add --uuid "if-dp2eth0" --mode "host" --port_name "eth0" --owner_datapath_uuid "dp-2" --network_uuid "nw-public1" --mac_address "02:01:00:00:00:02" --ipv4_address "172.16.90.11"
vnctl interfaces add --uuid "if-dp3eth0" --mode "host" --port_name "eth0" --owner_datapath_uuid "dp-3" --network_uuid "nw-public2" --mac_address "02:01:00:00:00:03" --ipv4_address "172.16.91.10"

#vnctl datapaths networks add dp-1 nw-public1 --interface_uuid "if-dp1eth0" --mac_address "02:00:01:aa:01:01"
#vnctl datapaths networks add dp-2 nw-public1 --interface_uuid "if-dp2eth0" --mac_address "02:00:01:bb:01:01"
#vnctl datapaths networks add dp-3 nw-public2 --interface_uuid "if-dp3eth0" --mac_address "02:00:01:cc:01:01"

cat <<EOS
**********************************************
* DONE configuring OpenVNet physical network *
**********************************************
EOS
