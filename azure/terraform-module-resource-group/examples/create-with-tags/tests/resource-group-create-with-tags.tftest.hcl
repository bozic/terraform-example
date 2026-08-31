provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  use_oidc        = var.client_secret == ""

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
