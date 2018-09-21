#!/bin/bash
echo "Cloning devstack git repository"
#rm -rf devstack
test -d devstack || git clone https://git.openstack.org/openstack-dev/devstack -v