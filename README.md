# Gaviti Integration Infrastructure

This project provisions all necessary Azure infrastructure for securely integrating with the Gaviti Accounts Receivable platform using Azure Function Apps.

## 📁 Folder Structure

infrastructure/
├── gaviti-project/
│ ├── main.bicep
│ └── modules/
│ ├── appServicePlan.bicep
│ ├── dnsZone.bicep
│ ├── functionApp.bicep
│ ├── keyVault.bicep
│ └── nsg.bicep
├── shared-modules/ # Optional for reusable logic
├── function-code/ # Optional location for ZIPs or source
└── deploy-gaviti.bash


## 🧱 Components

### 🔧 Function Apps
Deployed per environment using the naming convention: fa-{definedname}-{env}

Examples:
- `fa-gaviti-prod`
- `fa-gaviti-dev`

Each contains two triggers:
- `uploadInvoices`
- `retrieveCashReceipts`

### ☁️ App Service Plans
- `asp-sam-prod` – Premium v3 (P1v3)
- `asp-sam-sharedservices` – Elastic Premium (EP1, shared Dev/UAT)

### 🗄️ Storage Accounts
Globally unique and pre-created:
- `st-sam-prod`
- `st-sam-sharedservices`

### 🔐 Key Vault
- `kv-sharedservices`
- Secrets:
  - `GavitiApiKey`
  - `HubSpotApiKey`
  - `SqlConnectionString`
- Uses RBAC to authorize Function App access

### 🌐 VNet Integration
- All Function Apps integrate with `SAM-BaseNetwork`
- Subnet passed in at deploy time (`AppSvc-Prod-Subnet`)

### 🛡️ NSG (Network Security Group)
- Allows outbound to:
  - Gaviti: `api.gaviti.com`
  - HubSpot: `api.hubapi.com`
  - On-prem SQL: `10.0.0.0/16`
- Denies all other outbound

### 🔎 Private DNS Zone
- `sellarswipers.com` created and linked to your VNet
- Enables resolution for internal SQL hosts like `sql2.sellarswipers.com`

## 🚀 How to Deploy

```bash
chmod +x deploy-gaviti.bash
./deploy-gaviti.bash
The correct subnet exists

The named storage accounts are provisioned

You update example secrets in keyVault.bicep