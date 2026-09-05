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
    condition     = length(module.storage_account.container_ids) == 2
    error_message = "The module must create both requested containers."
  }

  assert {
    condition     = can(regex("^https://", module.storage_account.primary_blob_endpoint))
    error_message = "The primary blob endpoint must be an HTTPS URL."
  }
}
