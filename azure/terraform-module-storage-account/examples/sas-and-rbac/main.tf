provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_string" "name" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_resource_group" "example" {
  name     = "rg-storage-${random_string.name.result}"
  location = "westeurope"
}

module "storage_account" {
  source = "../../azure-storage-account"

  storage_account_name            = "st${random_string.name.result}"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = "westeurope"
  allow_nested_items_to_be_public = true

  containers = {
    artifacts = {
      container_access_type = "blob"
    }
  }

  sas_policy = {
    expiration_period = "7.00:00:00"
    expiration_action = "Block"
  }

  sas = {
    start  = "2026-01-01T00:00:00Z"
    expiry = "2030-01-01T00:00:00Z"

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
      write   = false
      delete  = false
      list    = true
      add     = false
      create  = false
      update  = false
      process = false
      tag     = false
      filter  = false
    }
  }

  role_assignments = {
    current_reader = {
      principal_id         = data.azurerm_client_config.current.object_id
      role_definition_name = "Storage Blob Data Reader"
      principal_type       = "ServicePrincipal"
    }
  }
}
