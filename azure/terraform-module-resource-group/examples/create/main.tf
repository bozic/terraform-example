provider "azurerm" {
  features {}
}

resource "random_pet" "name" {
  length = 2
}

module "resource_group" {
  source = "../../azure-resource-group"

  resource_group_name = "rg-${random_pet.name.id}"
  location            = "westeurope"
}
