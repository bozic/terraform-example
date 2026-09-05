output "id" {
  description = "The resource ID of the storage account."
  value       = local.storage_account_id
}

output "name" {
  description = "The name of the storage account."
  value       = local.storage_account_name
}

output "location" {
  description = "The location of the storage account."
  value       = local.storage_account_location
}

output "primary_access_key" {
  description = "The primary access key for the storage account."
  value       = local.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the storage account."
  value       = local.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the storage account."
  value       = local.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The secondary connection string for the storage account."
  value       = local.secondary_connection_string
  sensitive   = true
}

output "sas_token" {
  description = "The optional account SAS token generated from the primary access key."
  value       = var.sas == null ? null : data.azurerm_storage_account_sas.this[0].sas
  sensitive   = true
}

output "container_ids" {
  description = "Resource IDs of the managed blob containers, keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.id }
}

output "container_resource_manager_ids" {
  description = "Resource Manager IDs of the managed blob containers, keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.resource_manager_id }
}

output "container_urls" {
  description = "Blob URLs of the managed containers, keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.url }
}

output "role_assignment_ids" {
  description = "Resource IDs of the managed RBAC assignments, keyed by assignment name."
  value       = { for name, assignment in azurerm_role_assignment.this : name => assignment.id }
}
