provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = length(module.storage_account.container_ids) == 1
    error_message = "The module must create the configured container."
  }

  assert {
    condition     = length(module.storage_account.role_assignment_ids) == 1
    error_message = "The module must create the configured RBAC assignment."
  }
}
