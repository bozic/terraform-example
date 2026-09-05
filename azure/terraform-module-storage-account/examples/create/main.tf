provider "azurerm" {
  features {}
}

resource "random_string" "name" {
  length  = 12
  special = false
  upper   = false
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${random_string.name.result}"
  location = "westeurope"
}

module "storage_account" {
  source = "../../azure-storage-account"

  storage_account_name = "st${random_string.name.result}"
  resource_group_name  = azurerm_resource_group.example.name
  location             = azurerm_resource_group.example.location
}
