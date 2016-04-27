#!/bin/bash
set -ue

. 00_base.sh

cat <<EOS
**************************************************************
* Setting up OpenVNet virtual network: Single with firewalls *
**************************************************************
EOS

vnctl networks add --uuid "nw-vnet1" --display_name "vnet1" --ipv4_network "10.101.0.0" --ipv4_prefix "24" --domain_name "vnet1" --network_mode "virtual"

vnctl datapaths networks add dp-1 nw-vnet1 --interface_uuid "if-dp1eth0" --mac_address "02:00:00:aa:00:01"
vnctl datapaths networks add dp-2 nw-vnet1 --interface_uuid "if-dp2eth0" --mac_address "02:00:00:bb:00:01"
vnctl datapaths networks add dp-3 nw-vnet1 --interface_uuid "if-dp3eth0" --mac_address "02:00:00:cc:00:01"

vnctl interfaces add --uuid "if-v1" --port_name "if-v1" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:01" --ipv4_address "10.101.0.11" --enable_filtering "true"
vnctl interfaces add --uuid "if-v2" --port_name "if-v2" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:02" --ipv4_address "10.101.0.12" --enable_filtering "true"
vnctl interfaces add --uuid "if-v3" --port_name "if-v3" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:03" --ipv4_address "10.101.0.13" --enable_filtering "true"
vnctl interfaces add --uuid "if-v4" --port_name "if-v4" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:04" --ipv4_address "10.101.0.14"
vnctl interfaces add --uuid "if-v5" --port_name "if-v5" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:05" --ipv4_address "10.101.0.15"
vnctl interfaces add --uuid "if-v6" --port_name "if-v6" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:00:06" --ipv4_address "10.101.0.16"

vnctl interfaces add --uuid "if-dhcp1" --network_uuid "nw-vnet1" --mac_address "02:00:00:00:01:01" --ipv4_address "10.101.0.2" --mode "simulated"
vnctl network_services add --uuid "ns-dhcp1" --interface_uuid "if-dhcp1" --mode "dhcp"

vnctl filters add --uuid "fil-test1" --interface_uuid "if-v1" --mode "static" --egress-passthrough
vnctl filters static add "fil-test1" --protocol "tcp" --passthrough "true" --ipv4_address "0.0.0.0/0" --port_number "22"

vnctl filters add --uuid "fil-test2" --interface_uuid "if-v2" --mode "static" --egress-passthrough
vnctl filters static add "fil-test2" --protocol "icmp" --ipv4_address "10.101.0.15/32" --passthrough "true"
vnctl filters static add "fil-test2" --protocol "icmp" --ipv4_address "10.101.0.16/32" --passthrough "true"

vnctl filters add --uuid "fil-test3" --interface_uuid "if-v3" --mode "static" --egress-passthrough
vnctl filters static add "fil-test3" --protocol "tcp" --passthrough "true" --ipv4_address "0.0.0.0/0" --port_number "80"
vnctl filters static add "fil-test3" --protocol "tcp" --passthrough "true" --ipv4_address "10.101.0.15" --port_number "22"

vnctl filters static add "fil-test1" --protocol "arp" --ipv4_address "0.0.0.0/0" --passthrough "true"
vnctl filters static add "fil-test2" --protocol "arp" --ipv4_address "0.0.0.0/0" --passthrough "true"
vnctl filters static add "fil-test3" --protocol "arp" --ipv4_address "0.0.0.0/0" --passthrough "true"

# Allow udp for dhcp
vnctl filters static add "fil-test1" --protocol "udp" --ipv4_address "0.0.0.0/0" --port_number "0" --passthrough "true"
vnctl filters static add "fil-test2" --protocol "udp" --ipv4_address "0.0.0.0/0" --port_number "0" --passthrough "true"
vnctl filters static add "fil-test3" --protocol "udp" --ipv4_address "0.0.0.0/0" --port_number "0" --passthrough "true"

sudo restart vnet-vna
ssh itest2 "restart vnet-vna"
ssh itest3 "restart vnet-vna"

cat <<EOS
*******************************************************************
* DONE setting up OpenVNet virtual network: Single with firewalls *
*******************************************************************
EOS
