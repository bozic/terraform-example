provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = length(module.virtual_network.subnet_ids) == 2
    error_message = "The Virtual Network should create exactly two subnets."
  }

  assert {
    condition     = module.virtual_network.subnet_ids["frontend"] != ""
    error_message = "The frontend subnet ID must not be empty."
  }

  assert {
    condition     = module.virtual_network.subnet_ids["backend"] != ""
    error_message = "The backend subnet ID must not be empty."
  }
}
