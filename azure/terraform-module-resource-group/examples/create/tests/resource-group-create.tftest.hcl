provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.resource_group.id != ""
    error_message = "Resource Group ID must not be empty."
  }

  assert {
    condition     = can(regex("^rg-", module.resource_group.name))
    error_message = "Resource Group name must start with 'rg-'."
  }

  assert {
    condition     = module.resource_group.location == "westeurope"
    error_message = "Resource Group location must be 'westeurope'."
  }
}
