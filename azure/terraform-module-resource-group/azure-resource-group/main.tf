resource "azurerm_resource_group" "this" {
  count = var.resource_group_create ? 1 : 0

  name       = var.resource_group_name
  location   = var.location
  managed_by = var.managed_by
  tags       = var.tags
}

data "azurerm_resource_group" "this" {
  count = var.resource_group_create ? 0 : 1

  name = var.resource_group_name
}
