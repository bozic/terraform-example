output "id" {
  description = "The ID of the Storage Account."
  value       = local.storage_account_id
}

output "name" {
  description = "The name of the Storage Account."
  value       = local.storage_account_name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint of the Storage Account."
  value       = local.primary_blob_endpoint
}

output "secondary_blob_endpoint" {
  description = "The secondary blob endpoint of the Storage Account."
  value       = local.secondary_blob_endpoint
}

output "primary_dfs_endpoint" {
  description = "The primary DFS endpoint of the Storage Account."
  value       = local.primary_dfs_endpoint
}

output "secondary_dfs_endpoint" {
  description = "The secondary DFS endpoint of the Storage Account."
  value       = local.secondary_dfs_endpoint
}

output "primary_access_key" {
  description = "The primary access key of the Storage Account."
  value       = local.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key of the Storage Account."
  value       = local.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string of the Storage Account."
  value       = local.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The secondary connection string of the Storage Account."
  value       = local.secondary_connection_string
  sensitive   = true
}

output "primary_blob_connection_string" {
  description = "The primary blob connection string of the Storage Account."
  value       = local.primary_blob_connection_string
  sensitive   = true
}

output "secondary_blob_connection_string" {
  description = "The secondary blob connection string of the Storage Account."
  value       = local.secondary_blob_connection_string
  sensitive   = true
}

output "container_ids" {
  description = "The resource manager IDs of the created containers, keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.resource_manager_id }
}

output "container_urls" {
  description = "The data plane URLs of the created containers, keyed by container name."
  value       = { for name, container in azurerm_storage_container.this : name => container.url }
}

output "sas" {
  description = "The optional account SAS query string. Null when sas is not configured."
  value       = var.sas == null ? null : data.azurerm_storage_account_sas.this[0].sas
  sensitive   = true
}

output "rbac_role_assignment_ids" {
  description = "The IDs of the created RBAC role assignments, keyed by caller-defined assignment key."
  value       = { for name, assignment in azurerm_role_assignment.this : name => assignment.id }
}
