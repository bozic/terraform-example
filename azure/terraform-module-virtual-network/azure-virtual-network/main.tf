resource "azurerm_virtual_network" "this" {
  count = var.vnet_create ? 1 : 0

  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

data "azurerm_virtual_network" "this" {
  count = var.vnet_create ? 0 : 1

  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

locals {
  vnet_name = var.vnet_create ? azurerm_virtual_network.this[0].name : data.azurerm_virtual_network.this[0].name
  subnet_network_security_group_associations = {
    for name, subnet in var.subnets : name => subnet
    if subnet.network_security_group_id != null
  }
  subnet_route_table_associations = {
    for name, subnet in var.subnets : name => subnet
    if subnet.route_table_id != null
  }
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                          = each.key
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = local.vnet_name
  address_prefixes                              = each.value.address_prefixes
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.subnet_network_security_group_associations

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = local.subnet_route_table_associations

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}