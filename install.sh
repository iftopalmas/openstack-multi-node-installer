#!/bin/bash
clear

echo ""
echo "Configures an OpenStack multi-node private cloud using DevStack"
echo "Source: https://docs.openstack.org/devstack/latest/guides/multinode-lab.html"
echo ""
echo "Run $0 -h for help" 
echo ""

function usage()
{
   echo "Usage: $0 [options]"
   echo -e "\t-c or --controller installs the OpenStack controller"
   echo -e "\t-n or --node  Controller-IP     installs an OpenStack node that will be managed"
   echo -e "                                  by the controller with the given IP address"
   echo -e "                                  (run this for every node you want to add to the cluster)"  
}

function git_clone()
{
  #rm -rf devstack
  test -d devstack || git clone https://git.openstack.org/openstack-dev/devstack -v
  cd devstack
}

if [[ $# -lt 1 || $1 == "-h" || $1 == "/h" ]]; then
   usage
   exit 0
fi

if [[ $# -lt 2 && ($1 == "-n" || $1 == "--node") ]]; then
   usage
   exit 0
fi

apt-get install -y git

#Download DevStack
git_clone

USER="stack"
useradd -s /bin/bash -d /opt/$USER -m $USER

#Gives user root permission if it has not been given yet
cat /etc/sudoers | grep "$USER ALL=(ALL) NOPASSWD: ALL" > /dev/null || echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

if [[ $1 == "-c" || $1 == "--controller" ]]; then
  cp openstack-controller.sh /opt/$USER && chmod +x openstack-controller.sh
  sudo -i -u $USER ./openstack-controller.sh
elif [[ $1 == "-n" || $1 == "--node" ]]; then
  cp openstack-node.sh /opt/$USER && chmod +x openstack-node.sh
  #SERVICE_HOST = IP of the open stack controller
  SERVICE_HOST=$2
  sudo -i -u $USER ./openstack-node.sh $SERVICE_HOST
fi


