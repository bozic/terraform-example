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

module "key_vault" {
  source = "../../azure-key-vault"

  name                = "kv-${random_pet.name.id}"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = []
  }

  tags = {
    environment = "test"
    module      = "key-vault"
  }
}

data "azurerm_client_config" "current" {}
