output "id" {
  description = "The ID of the Key Vault."
  value       = var.key_vault_create ? azurerm_key_vault.this[0].id : data.azurerm_key_vault.this[0].id
}

output "name" {
  description = "The name of the Key Vault."
  value       = var.key_vault_create ? azurerm_key_vault.this[0].name : data.azurerm_key_vault.this[0].name
}

output "location" {
  description = "The location of the Key Vault."
  value       = var.key_vault_create ? azurerm_key_vault.this[0].location : data.azurerm_key_vault.this[0].location
}

output "vault_uri" {
  description = "The URI of the Key Vault."
  value       = var.key_vault_create ? azurerm_key_vault.this[0].vault_uri : data.azurerm_key_vault.this[0].vault_uri
}
