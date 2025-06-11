// File: gaviti-project/modules/appServicePlan.bicep
@description('Location for App Service Plans')
param location string

resource prodPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
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

resource sharedPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
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
