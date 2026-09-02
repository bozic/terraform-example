provider "azurerm" {
  features {}
}

resource "random_pet" "name" {
  length = 2
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_pet.name.id}"
  location = "westeurope"
}

module "virtual_network" {
  source = "../../azure-virtual-network"

  vnet_name           = "vnet-${random_pet.name.id}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]
}
