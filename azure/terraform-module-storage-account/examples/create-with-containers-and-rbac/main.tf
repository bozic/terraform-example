provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

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

  containers = {
    data = {
      container_access_type = "private"
    }
    logs = {
      name                  = "logs-${random_string.name.result}"
      container_access_type = "blob"
      metadata = {
        purpose = "logs"
      }
    }
  }

  role_assignments = {
    reader = {
      role_definition_name = "Storage Blob Data Reader"
      principal_id         = data.azurerm_client_config.current.object_id
    }
  }

  sas_token_enabled = true
  sas = {
    start  = "2024-01-01T00:00:00Z"
    expiry = "2030-01-01T00:00:00Z"

    resource_types = {
      service   = true
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
      add     = true
      create  = true
      update  = false
      process = false
      tag     = false
      filter  = false
    }
  }

  tags = {
    environment = "test"
    module      = "storage-account"
  }
}
