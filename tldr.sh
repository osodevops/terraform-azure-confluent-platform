#!/bin/bash
# IMPORTANT: The following script assumes you have already run an 'az login' for your local machine
sh ssh-generation.sh
sh state-generation.sh
cd production || exit
terragrunt run-all apply --terragrunt-non-interactive
az container start --resource-group oso-production-resources --name oso-devops-cp-ansible
az container attach --resource-group oso-production-resources --name oso-devops-cp-ansible
cd ../production/control-centre || exit
echo "Save this key to SSH onto instances:"
cat ../../modules/resource-group/oso-confluent-ssh
CC_IP=$(terragrunt output public_ip_address)
echo "Control Centre can be accessed at http://"$CC_IP":9021" | tr -d '"'
cd ../rest-proxy || exit
RP_IP=$(terragrunt output public_ip_address)
echo "Rest Proxy can be accessed at http://"$RP_IP":8082" | tr -d '"'
