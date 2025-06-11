// File: gaviti-project/modules/dnsZone.bicep
@description('Deployment location')
param location string

@description('ID of the VNet to link to the DNS zone')
param vnetId string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2023-05-01' = {
  name: 'sellarswipers.com'
  location: 'global'
  properties: {}
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2023-05-01' = {
  name: 'sellarswipers.com-link'
  parent: privateDnsZone
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    registrationEnabled: false
  }
  dependsOn: [privateDnsZone]
}
