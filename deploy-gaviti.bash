#!/bin/bash

#!/bin/bash

# Set your target resource group and subnet
RESOURCE_GROUP="fa-gaviti-dev"
SUBNET_NAME="dev" # Make this an Environment Variable""

# Deploy the Gaviti infrastructure
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file infrastructure/gaviti-project/main.bicep \
  --parameters subnetName=$SUBNET_NAME
  --parameters location="Central US"