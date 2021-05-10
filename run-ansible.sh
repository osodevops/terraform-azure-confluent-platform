#!/bin/bash
az container start --resource_group oso-production-resources --name oso-devops-cp-ansible
az container attach --resource_group oso-production-resources --name oso-devops-cp-ansible