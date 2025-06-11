#!/bin/bash

RESOURCE_GROUP="your-resource-group"
SUBNET_NAME="AppSvc-Prod-Subnet"

az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file infrastructure/gaviti-project/main.bicep \
  --parameters subnetName=$SUBNET_NAME
