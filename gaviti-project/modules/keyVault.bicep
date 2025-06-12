// File: gaviti-project/modules/keyVault.bicep
@description('Deployment location')
param location string


resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-sharedservices'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [] // Access policies are handled using RBAC
    enableRbacAuthorization: true
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
  }
}

// Example secrets
// resource gavitiApiKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   name: '${keyVault.name}/GavitiApiKey'
//   properties: {
//     value: 'ReplaceThisWithYourGavitiKey'
//   }
// }

// resource hubSpotApiKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   name: '${keyVault.name}/HubSpotApiKey'
//   properties: {
//     value: 'ReplaceThisWithYourHubSpotKey'
//   }
// }

// resource sqlConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   name: '${keyVault.name}/SqlConnectionString'
//   properties: {
//     value: 'ReplaceThisWithYourSqlConnectionString'
//   }
// }

output keyVaultName string = 'kv-sharedservices'
