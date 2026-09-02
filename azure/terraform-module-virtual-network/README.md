# Azure Virtual Network Module

Manages an Azure Virtual Network with optional standalone subnets and per-subnet
Network Security Group and route table associations.

## Create a Virtual Network

```hcl
module "virtual_network" {
  source = "./azure-virtual-network"

  vnet_name           = "vnet-production"
  resource_group_name = "rg-production"
  location            = "westeurope"
  address_space       = ["10.0.0.0/16"]

  subnets = {
    frontend = {
      address_prefixes          = ["10.0.1.0/24"]
      network_security_group_id = azurerm_network_security_group.frontend.id
      route_table_id            = azurerm_route_table.frontend.id
    }
    backend = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}
```

## Query an Existing Virtual Network

```hcl
module "virtual_network" {
  source = "./azure-virtual-network"

  vnet_create         = false
  vnet_name           = "vnet-existing"
  resource_group_name = "rg-production"
  location           = "westeurope"
}
```

Set `subnets` to create additional standalone subnets in an existing virtual
network. Subnets that are already managed outside this module should not be
included.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
