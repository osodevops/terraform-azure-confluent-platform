#!/bin/bash
az container start --resource-group oso-production-resources --name oso-devops-cp-ansible
az container attach --resource-group oso-production-resources --name oso-devops-cp-ansible