#!/bin/bash
echo "Generating SSH key to be used for Confluent Virtual Machines"
ssh-keygen -t rsa -f oso-confluent-ssh -N ""
cp oso-confluent-ssh.pub modules/confluent_node
cp oso-confluent-ssh.pub modules/confluent_node_public
mv oso-confluent-ssh modules/resource_group/oso-confluent-ssh.pem
