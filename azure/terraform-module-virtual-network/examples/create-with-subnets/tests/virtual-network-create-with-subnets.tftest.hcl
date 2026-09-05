provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = length(module.virtual_network.subnet_ids) == 2
    error_message = "The module must create both configured subnets."
  }

  assert {
    condition     = contains(keys(module.virtual_network.subnet_ids), "application") && contains(keys(module.virtual_network.subnet_ids), "data")
    error_message = "Subnet IDs must be keyed by their configured names."
  }
}