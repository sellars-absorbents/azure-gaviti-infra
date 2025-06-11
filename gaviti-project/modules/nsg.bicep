// File: gaviti-project/modules/nsg.bicep
@description('Location for the NSG')
param location string

@description('Name of the subnet to associate NSG with')
param subnetName string

@description('Name of the VNet containing the subnet')
param vnetName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'nsg-functions-prod'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Gaviti'
        properties: {
          priority: 100
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefixes: [
            'api.gaviti.com',
            '52.85.110.0/24' // placeholder if FQDN not supported
          ]
        }
      }
      {
        name: 'Allow-HubSpot'
        properties: {
          priority: 110
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefixes: [
            'api.hubapi.com',
            '104.18.0.0/16' // placeholder
          ]
        }
      }
      {
        name: 'Allow-OnPrem-SQL'
        properties: {
          priority: 120
          direction: 'Outbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '*'
          destinationAddressPrefixes: [
            '10.0.0.0/16' // your on-prem network range
          ]
        }
      }
      {
        name: 'Deny-All-Outbound'
        properties: {
          priority: 200
          direction: 'Outbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource subnetAssoc 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [nsg]
}
