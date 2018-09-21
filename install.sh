#!/bin/bash
clear

echo ""
echo "Configures an OpenStack multi-node private cloud using DevStack"
echo "Source: https://docs.openstack.org/devstack/latest/guides/multinode-lab.html"
echo ""
echo "Run $0 -h for help" 
echo ""

if [[ $# -lt 1 || $1 == "-h" || $1 == "/h" ]]; then
   echo "Usage: $0 [options]"
   echo -e "\t-c or --controller installs the OpenStack controller"
   echo -e "\t-n or --node       installs an OpenStack node"
   echo -e "                     (run this for every node you want to add to the cluster)"
   exit 0
fi

apt-get install -y git

USER="stack"
useradd -s /bin/bash -d /opt/$USER -m $USER
cp openstack-controller.sh /opt/$USER

#Gives user root permission if it has not been given yet
cat /etc/sudoers | grep "$USER ALL=(ALL) NOPASSWD: ALL" > /dev/null || echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

if [[ $1 == "-c" || $1 == "--controller" ]]; then
  chmod +x openstack-controller.sh
  CLEAN=$2
  sudo -i -u $USER ./openstack-controller.sh $CLEAN
elif [[ $1 == "-n" || $1 == "--node" ]]; then
  echo "Nodes"
  #SERVICE_HOST = IP of the open stack controller
  #sudo -i -u $USER ./openstack-node.sh $SERVICE_HOST
fi


