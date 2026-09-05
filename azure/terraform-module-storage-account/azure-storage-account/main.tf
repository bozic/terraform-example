resource "azurerm_storage_account" "this" {
  count = var.storage_account_create ? 1 : 0

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  access_tier                     = var.access_tier
  https_traffic_only_enabled      = var.https_traffic_only_enabled
  min_tls_version                 = var.min_tls_version
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  is_hns_enabled                  = var.is_hns_enabled
  tags                            = var.tags

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

data "azurerm_storage_account" "this" {
  count = var.storage_account_create ? 0 : 1

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

locals {
  storage_account_id                 = var.storage_account_create ? azurerm_storage_account.this[0].id : data.azurerm_storage_account.this[0].id
  storage_account_primary_access_key = var.storage_account_create ? azurerm_storage_account.this[0].primary_access_key : data.azurerm_storage_account.this[0].primary_access_key
  storage_account_primary_connection_string = (
    var.storage_account_create ? azurerm_storage_account.this[0].primary_connection_string : data.azurerm_storage_account.this[0].primary_connection_string
  )
}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = coalesce(each.value.name, each.key)
  storage_account_id    = local.storage_account_id
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                            = local.storage_account_id
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_id
  principal_id                     = each.value.principal_id
  principal_type                   = each.value.principal_type
  description                      = each.value.description
  condition                        = each.value.condition
  condition_version                = each.value.condition_version
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}

data "azurerm_storage_account_sas" "this" {
  count = var.sas_token_enabled ? 1 : 0

  connection_string = local.storage_account_primary_connection_string
  https_only        = var.sas.https_only
  ip_addresses      = var.sas.ip_addresses
  signed_version    = var.sas.signed_version
  start             = var.sas.start
  expiry            = var.sas.expiry

  resource_types {
    service   = var.sas.resource_types.service
    container = var.sas.resource_types.container
    object    = var.sas.resource_types.object
  }

  services {
    blob  = var.sas.services.blob
    queue = var.sas.services.queue
    table = var.sas.services.table
    file  = var.sas.services.file
  }

  permissions {
    read    = var.sas.permissions.read
    write   = var.sas.permissions.write
    delete  = var.sas.permissions.delete
    list    = var.sas.permissions.list
    add     = var.sas.permissions.add
    create  = var.sas.permissions.create
    update  = var.sas.permissions.update
    process = var.sas.permissions.process
    tag     = var.sas.permissions.tag
    filter  = var.sas.permissions.filter
  }
}
