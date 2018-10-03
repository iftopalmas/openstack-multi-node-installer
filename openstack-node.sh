#!/bin/bash

function net_interface()
{
 ifconfig | head -n 1 | cut -d' ' -f1 | cut -d':' -f1 
}

# $1 - network interface name
function ip_addr()
{
  ip -4 addr show $1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
}

./download.sh
cd devstack

echo "Starting node installation"
FLAT_INTERFACE=$(net_interface)
HOST_IP=$(ip_addr $FLAT_INTERFACE)
USER="stack"
PASSWD=$USER
SERVICE_HOST=$1

echo "[[local|localrc]]
HOST_IP=$HOST_IP
FLAT_INTERFACE=$FLAT_INTERFACE
FIXED_RANGE=192.168.0.0/24
FIXED_NETWORK_SIZE=256
FLOATING_RANGE=10.105.0.128/25
MULTI_HOST=1
LOGFILE=/opt/stack/logs/stack.sh.log
ADMIN_PASSWORD=$PASSWD
DATABASE_PASSWORD=$PASSWD
RABBIT_PASSWORD=$PASSWD
SERVICE_PASSWORD=$PASSWD
DATABASE_TYPE=mysql
SERVICE_HOST=$SERVICE_HOST
MYSQL_HOST=$SERVICE_HOST
RABBIT_HOST=$SERVICE_HOST
GLANCE_HOSTPORT=$SERVICE_HOST:9292
ENABLED_SERVICES=n-cpu,q-agt,n-api-meta,c-vol,placement-client
NOVA_VNC_ENABLED=True
NOVNCPROXY_URL="http://$SERVICE_HOST:6080/vnc_auto.html"
VNCSERVER_LISTEN=$HOST_IP
VNCSERVER_PROXYCLIENT_ADDRESS=$HOST_IP" > local.conf  

./stack.sh

echo ""
echo ""
echo "YOUR INTERVENTION IS REQUIRED NOW!"
echo ""
echo ""
echo "After each compute node is stacked, verify it shows up in the nova service-list --binary nova-compute output. The compute service is registered in the cell database asynchronously so this may require polling.

Once the compute node services shows up, run the ./tools/discover_hosts.sh script from the control node to map compute hosts to the single cell.

The compute service running on the primary control node will be discovered automatically when the control node is stacked so this really only needs to be performed for subnodes.

For more information, check out this page: https://docs.openstack.org/devstack/latest/guides/multinode-lab.html
"
