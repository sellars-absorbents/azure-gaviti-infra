// File: gaviti-project/modules/functionApp.bicep
@description('Location for the Function App')
param location string

@description('Name of the Function App')
param functionAppName string

@description('Name of the App Service Plan to attach')
param appServicePlanName string

@description('Name of the associated Storage Account')
param storageAccountName string

@description('Resource ID of the VNet subnet for integration')
param subnetResourceId string

@description('Name of the Key Vault for secret references')
param keyVaultName string

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: '@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/SqlConnectionString/)'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'GavitiApiKey'
          value: concat('@Microsoft.KeyVault(SecretUri=https://', keyVaultName, '.vault.azure.net/secrets/GavitiApiKey/)')
        }
        {
          name: 'HubSpotApiKey'
          value: concat('@Microsoft.KeyVault(SecretUri=https://', keyVaultName, '.vault.azure.net/secrets/HubSpotApiKey/)')
        }
      ]
      vnetRouteAllEnabled: true
    }
    httpsOnly: true
  }
}

resource vnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  name: '${functionApp.name}/vnet'
  properties: {
    subnetResourceId: subnetResourceId
  }
  dependsOn: [
    functionApp
  ]
}
