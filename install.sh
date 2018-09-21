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

if [[ $# -lt 1 || $1 == "-h" || $1 == "/h" ]]; then
   usage
   exit 0
fi

if [[ $# -lt 2 && ($1 == "-n" || $1 == "--node") ]]; then
   usage
   exit 0
fi

apt-get install -y git

USERNAME="stack"
cp *.sh /opt/$USERNAME && chmod a+x /opt/$USERNAME/*.sh

useradd -s /bin/bash -d /opt/$USERNAME -m $USERNAME

#Gives user root permission if it has not been given yet
cat /etc/sudoers | grep "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /dev/null || echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

if [[ $1 == "-c" || $1 == "--controller" ]]; then
  sudo -i -u $USERNAME ./openstack-controller.sh
elif [[ $1 == "-n" || $1 == "--node" ]]; then
  #SERVICE_HOST = IP of the open stack controller
  SERVICE_HOST=$2
  sudo -i -u $USERNAME ./openstack-node.sh $SERVICE_HOST
fi


