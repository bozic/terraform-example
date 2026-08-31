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
  managed_by          = "/subscriptions/00000000-0000-0000-0000-000000000000"

  tags = {
    environment = "test"
    module      = "resource-group"
    managed_by  = "terraform"
  }
}
