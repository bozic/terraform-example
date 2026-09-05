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
    condition     = can(regex("^kv-", module.key_vault.name))
    error_message = "Key Vault name must start with 'kv-'."
  }

  assert {
    condition     = can(regex("^https://", module.key_vault.vault_uri))
    error_message = "Key Vault URI must use HTTPS."
  }
}
