provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  use_oidc        = var.client_secret == ""

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
