provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

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
    data = {}
  }

  sas = {
    start  = "2026-01-01T00:00:00Z"
    expiry = "2027-01-01T00:00:00Z"
    resource_types = {
      service   = false
      container = true
      object    = true
    }
    services = {
      blob  = true
      queue = false
      table = false
      file  = false
    }
    permissions = {
      read    = true
      write   = true
      delete  = false
      list    = true
      add     = false
      create  = true
      update  = true
      process = false
      tag     = false
      filter  = false
    }
  }
  rbac_role_assignments = {
    current_principal = {
      principal_id         = data.azurerm_client_config.current.object_id
      role_definition_name = "Storage Blob Data Contributor"
    }
  }
}
