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

module "storage_account" {
  source = "../../azure-storage-account"

  storage_account_name = replace("st${random_pet.name.id}", "-", "")
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location

  containers = {
    uploads = {}
    archive = {
      metadata = {
        purpose = "archive"
      }
    }
  }
}
