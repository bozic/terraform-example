locals {
  vnet_name     = var.vnet_create ? azurerm_virtual_network.this[0].name : data.azurerm_virtual_network.this[0].name
  vnet_location = var.vnet_create ? azurerm_virtual_network.this[0].location : data.azurerm_virtual_network.this[0].location
}

resource "azurerm_virtual_network" "this" {
  count = var.vnet_create ? 1 : 0

  name                    = var.vnet_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = var.address_space
  dns_servers             = var.dns_servers
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  tags                    = var.tags

  lifecycle {
    precondition {
      condition     = var.address_space != null && length(var.address_space) > 0
      error_message = "address_space must contain at least one CIDR block when vnet_create is true."
    }
  }
}

data "azurerm_virtual_network" "this" {
  count = var.vnet_create ? 0 : 1

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for name, subnet in var.subnets : name => subnet
    if subnet.network_security_group_association_create
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id

  lifecycle {
    precondition {
      condition     = each.value.network_security_group_id != null
      error_message = "network_security_group_id must be set when network_security_group_association_create is true."
    }
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = {
    for name, subnet in var.subnets : name => subnet
    if subnet.route_table_association_create
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id

  lifecycle {
    precondition {
      condition     = each.value.route_table_id != null
      error_message = "route_table_id must be set when route_table_association_create is true."
    }
  }
}
