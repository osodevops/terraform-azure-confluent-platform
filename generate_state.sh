#!/bin/bash
az group create --location uksouth --resource-group terraform-state
az storage account create --name confluentstate --resource-group terraform-state --location uksouth --sku Standard_LRS