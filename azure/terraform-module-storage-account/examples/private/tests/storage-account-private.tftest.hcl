provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.storage_account.id != ""
    error_message = "Storage account ID must not be empty."
  }

  assert {
    condition     = length(module.storage_account.container_ids) == 2
    error_message = "The module must create both configured containers."
  }

  assert {
    condition     = module.storage_account.container_ids["data"] != ""
    error_message = "The data container ID must not be empty."
  }
}
