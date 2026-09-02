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

resource "azurerm_network_security_group" "frontend" {
  name                = "nsg-frontend-${random_pet.name.id}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend-${random_pet.name.id}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "frontend" {
  name                = "rt-frontend-${random_pet.name.id}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "backend" {
  name                = "rt-backend-${random_pet.name.id}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "virtual_network" {
  source = "../../azure-virtual-network"

  vnet_name           = "vnet-${random_pet.name.id}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]

  subnets = {
    frontend = {
      address_prefixes          = ["10.0.1.0/24"]
      network_security_group_id = azurerm_network_security_group.frontend.id
      route_table_id            = azurerm_route_table.frontend.id
    }
    backend = {
      address_prefixes          = ["10.0.2.0/24"]
      network_security_group_id = azurerm_network_security_group.backend.id
      route_table_id            = azurerm_route_table.backend.id
    }
  }
}
