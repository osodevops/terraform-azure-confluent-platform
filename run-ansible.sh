#!/bin/bash
az container start --resource-group oso-sandbox-resources --name oso-devops-cp-ansible
az container attach --resource-group oso-sandbox-resources --name oso-devops-cp-ansible