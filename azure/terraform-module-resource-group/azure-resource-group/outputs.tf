output "id" {
  description = "The ID of the Resource Group."
  value       = var.resource_group_create ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.this[0].id
}

output "name" {
  description = "The name of the Resource Group."
  value       = var.resource_group_create ? azurerm_resource_group.this[0].name : data.azurerm_resource_group.this[0].name
}

output "location" {
  description = "The location of the Resource Group."
  value       = var.resource_group_create ? azurerm_resource_group.this[0].location : data.azurerm_resource_group.this[0].location
}
