@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the VNet and subnet used for integration')
param vnetName string
param subnetName string

@description('Name of the existing storage account to be used by all function apps')
param storageAccountName string

// ------------------------------------------------------
// Resource references
// ------------------------------------------------------
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' existing = {
  parent: vnet
  name: subnetName
}

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

// ------------------------------------------------------
// App Service Plans
// ------------------------------------------------------
resource aspSamProd 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-sam-prod'
  location: location
  sku: {
    name: 'P1v3'
    tier: 'PremiumV3'
    size: 'P1v3'
    capacity: 1
  }
  kind: 'app'
  properties: {
    reserved: false
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}

resource aspSamShared 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-sam-sharedservices'
  location: location
  sku: {
    name: 'EP1'
    tier: 'ElasticPremium'
    size: 'EP1'
    capacity: 1
  }
  kind: 'elastic'
  properties: {
    reserved: true
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}

// ------------------------------------------------------
// Function Apps
// ------------------------------------------------------
module faGavitiProd 'modules/functionApp.bicep' = {
    name: 'fa-gaviti-prod'
    params: {
        location: location
        functionAppName: 'fa-gaviti-prod'
        appServicePlanId: aspSamProd.id
        storageAccountName: storage.name
        subnetResourceId: subnet.id
    }
}

module faGavitiDev 'functionApp.bicep' = {
  name: 'fa-gaviti-dev'
  params: {
    location: location
    functionAppName: 'fa-gaviti-dev'
    appServicePlanId: aspSamShared.id
    storageAccountName: storage.name
    subnetResourceId: subnet.id
  }
}

module faGavitiUat 'functionApp.bicep' = {
  name: 'fa-gaviti-uat'
  params: {
    location: location
    functionAppName: 'fa-gaviti-uat'
    appServicePlanId: aspSamShared.id
    storageAccountName: storage.name
    subnetResourceId: subnet.id
  }
}
