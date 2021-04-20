#!/bin/bash
Echo "Generating SSH key to be used for Confluent Virtual Machines"
ssh-keygen -t rsa -f oso-confluent-ssh -N ""
cp oso-confluent-ssh.pub modules/confluent_node
mv oso-confluent-ssh.pub azuredevops
mv oso-confluent-ssh modules/resource-group
