resource "azurerm_key_vault" "this" {
  count = var.key_vault_create ? 1 : 0

  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.rbac_authorization_enabled
  purge_protection_enabled        = var.purge_protection_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  tags                            = var.tags

  network_acls {
    bypass                     = var.network_acls.bypass
    default_action             = "Deny"
    ip_rules                   = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }
}

data "azurerm_key_vault" "this" {
  count = var.key_vault_create ? 0 : 1

  name                = var.name
  resource_group_name = var.resource_group_name
}
