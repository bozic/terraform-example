# Azure Virtual Network Module

Manages an Azure Virtual Network with support for the create-or-query pattern and zero or more standalone subnets. Each subnet can independently associate a Network Security Group and Route Table.

## Usage

### Create a Virtual Network and subnets

```hcl
module "virtual_network" {
  source = "./azure-virtual-network"

  vnet_name           = "vnet-production"
  resource_group_name = "rg-production"
  location            = "westeurope"
  address_space       = ["10.0.0.0/16"]

  subnets = {
    application = {
      address_prefixes          = ["10.0.1.0/24"]
      network_security_group_id = azurerm_network_security_group.application.id
      route_table_id            = azurerm_route_table.application.id
    }
    data = {
      address_prefixes          = ["10.0.2.0/24"]
      network_security_group_id = azurerm_network_security_group.data.id
      route_table_id            = azurerm_route_table.data.id
    }
  }
}
```

### Query an existing Virtual Network

```hcl
module "virtual_network" {
  source = "./azure-virtual-network"

  vnet_create         = false
  vnet_name           = "vnet-existing"
  resource_group_name = "rg-existing"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->