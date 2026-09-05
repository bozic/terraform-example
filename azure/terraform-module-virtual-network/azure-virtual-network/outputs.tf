output "id" {
  description = "The ID of the Virtual Network."
  value       = var.vnet_create ? azurerm_virtual_network.this[0].id : data.azurerm_virtual_network.this[0].id
}

output "name" {
  description = "The name of the Virtual Network."
  value       = local.vnet_name
}

output "location" {
  description = "The location of the Virtual Network."
  value       = var.vnet_create ? azurerm_virtual_network.this[0].location : data.azurerm_virtual_network.this[0].location
}

output "subnet_ids" {
  description = "A map of created subnet IDs, keyed by subnet name."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}