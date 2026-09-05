provider "azurerm" {
  features {}
}

run "apply" {
  command = apply

  assert {
    condition     = module.key_vault.id != ""
    error_message = "Key Vault ID must not be empty."
  }

  assert {
    condition     = module.key_vault.location == "westeurope"
    error_message = "Key Vault location must be 'westeurope'."
  }
}
