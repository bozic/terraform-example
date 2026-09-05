output "id" {
  description = "The ID of the Storage Account."
  value       = local.storage_account_id
}

output "name" {
  description = "The name of the Storage Account."
  value       = var.storage_account_create ? azurerm_storage_account.this[0].name : data.azurerm_storage_account.this[0].name
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = var.storage_account_create ? azurerm_storage_account.this[0].primary_blob_endpoint : data.azurerm_storage_account.this[0].primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = local.storage_account_primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Storage Account."
  value       = var.storage_account_create ? azurerm_storage_account.this[0].secondary_access_key : data.azurerm_storage_account.this[0].secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The connection string associated with the primary location."
  value       = local.storage_account_primary_connection_string
  sensitive   = true
}

output "identity" {
  description = "The identity block exported by the Storage Account, containing the `principal_id` and `tenant_id`."
  value       = var.storage_account_create ? try(azurerm_storage_account.this[0].identity, null) : try(data.azurerm_storage_account.this[0].identity, null)
}

output "containers" {
  description = "A map of the created Storage Containers, keyed by the same key as `var.containers`."
  value = {
    for k, v in azurerm_storage_container.this : k => {
      id                  = v.id
      name                = v.name
      resource_manager_id = v.resource_manager_id
      url                 = v.url
    }
  }
}

output "role_assignment_ids" {
  description = "A map of the created RBAC Role Assignment IDs, keyed by the same key as `var.role_assignments`."
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}

output "sas_token" {
  description = "The generated Shared Access Signature (SAS) token, when `sas_token_enabled` is `true`."
  value       = var.sas_token_enabled ? data.azurerm_storage_account_sas.this[0].sas : null
  sensitive   = true
}
