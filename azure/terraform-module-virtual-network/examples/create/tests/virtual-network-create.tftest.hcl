provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.virtual_network.id != ""
    error_message = "Virtual Network ID must not be empty."
  }

  assert {
    condition     = can(regex("^vnet-", module.virtual_network.name))
    error_message = "Virtual Network name must start with 'vnet-'."
  }

  assert {
    condition     = length(module.virtual_network.subnet_ids) == 0
    error_message = "The module should not create subnets when none are configured."
  }
}