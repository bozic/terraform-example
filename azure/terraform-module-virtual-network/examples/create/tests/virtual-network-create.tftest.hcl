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
    condition     = module.virtual_network.location == "westeurope"
    error_message = "Virtual Network location must be 'westeurope'."
  }

  assert {
    condition     = length(module.virtual_network.subnet_ids) == 0
    error_message = "The Virtual Network should not create subnets by default."
  }
}
