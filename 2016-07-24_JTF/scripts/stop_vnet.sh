#!/bin/bash
set -ue

cd /home/edison/openvnet/vnet

kill $(cat vnmgr.pid)
kill $(cat vna.pid)
kill $(cat webapi.pid)
