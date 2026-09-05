provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.storage_account.sas != null
    error_message = "The configured account SAS must be exposed."
  }

  assert {
    condition     = length(module.storage_account.rbac_role_assignment_ids) == 1
    error_message = "The configured RBAC role assignment must be created."
  }

  assert {
    condition     = contains(keys(module.storage_account.container_ids), "data")
    error_message = "The data container must be created."
  }
}
