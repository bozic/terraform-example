output "id" {
  description = "The ID of the Virtual Network."
  value       = var.vnet_create ? azurerm_virtual_network.this[0].id : data.azurerm_virtual_network.this[0].id
}

output "name" {
  description = "The name of the Virtual Network."
  value       = local.vnet_name
}

output "location" {
  description = "The Azure region of the Virtual Network."
  value       = local.vnet_location
}

output "subnet_ids" {
  description = "The IDs of the subnets created by this module, keyed by subnet name."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}
