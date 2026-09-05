provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.storage_account.id != ""
    error_message = "Storage Account ID must not be empty."
  }

  assert {
    condition     = can(regex("^st", module.storage_account.name))
    error_message = "Storage Account name must start with 'st'."
  }

  assert {
    condition     = module.storage_account.primary_blob_endpoint != ""
    error_message = "Storage Account primary blob endpoint must not be empty."
  }

  assert {
    condition     = length(module.storage_account.containers) == 0
    error_message = "No containers should be created by default."
  }
}
