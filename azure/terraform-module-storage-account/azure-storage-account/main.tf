resource "azurerm_storage_account" "this" {
  count = var.storage_account_create ? 1 : 0

  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  access_tier                     = var.access_tier
  https_traffic_only_enabled      = var.https_traffic_only_enabled
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication
  is_hns_enabled                  = var.is_hns_enabled
  tags                            = var.tags

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

data "azurerm_storage_account" "this" {
  count = var.storage_account_create ? 0 : 1

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

locals {
  storage_account_id               = var.storage_account_create ? azurerm_storage_account.this[0].id : data.azurerm_storage_account.this[0].id
  storage_account_name             = var.storage_account_create ? azurerm_storage_account.this[0].name : data.azurerm_storage_account.this[0].name
  primary_access_key               = var.storage_account_create ? azurerm_storage_account.this[0].primary_access_key : data.azurerm_storage_account.this[0].primary_access_key
  secondary_access_key             = var.storage_account_create ? azurerm_storage_account.this[0].secondary_access_key : data.azurerm_storage_account.this[0].secondary_access_key
  primary_connection_string        = var.storage_account_create ? azurerm_storage_account.this[0].primary_connection_string : data.azurerm_storage_account.this[0].primary_connection_string
  secondary_connection_string      = var.storage_account_create ? azurerm_storage_account.this[0].secondary_connection_string : data.azurerm_storage_account.this[0].secondary_connection_string
  primary_blob_endpoint            = var.storage_account_create ? azurerm_storage_account.this[0].primary_blob_endpoint : data.azurerm_storage_account.this[0].primary_blob_endpoint
  secondary_blob_endpoint          = var.storage_account_create ? azurerm_storage_account.this[0].secondary_blob_endpoint : data.azurerm_storage_account.this[0].secondary_blob_endpoint
  primary_dfs_endpoint             = var.storage_account_create ? azurerm_storage_account.this[0].primary_dfs_endpoint : data.azurerm_storage_account.this[0].primary_dfs_endpoint
  secondary_dfs_endpoint           = var.storage_account_create ? azurerm_storage_account.this[0].secondary_dfs_endpoint : data.azurerm_storage_account.this[0].secondary_dfs_endpoint
  primary_blob_connection_string   = var.storage_account_create ? azurerm_storage_account.this[0].primary_blob_connection_string : data.azurerm_storage_account.this[0].primary_blob_connection_string
  secondary_blob_connection_string = var.storage_account_create ? azurerm_storage_account.this[0].secondary_blob_connection_string : data.azurerm_storage_account.this[0].secondary_blob_connection_string
}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                              = each.key
  storage_account_id                = local.storage_account_id
  container_access_type             = each.value.container_access_type
  default_encryption_scope          = each.value.default_encryption_scope
  encryption_scope_override_enabled = each.value.default_encryption_scope == null ? null : each.value.encryption_scope_override_enabled
  metadata                          = each.value.metadata
}

data "azurerm_storage_account_sas" "this" {
  count = var.sas == null ? 0 : 1

  connection_string = local.primary_connection_string
  https_only        = var.sas.https_only
  ip_addresses      = var.sas.ip_addresses
  signed_version    = var.sas.signed_version
  start             = var.sas.start
  expiry            = var.sas.expiry

  lifecycle {
    precondition {
      condition     = var.shared_access_key_enabled
      error_message = "shared_access_key_enabled must be true when sas is configured."
    }
  }

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

resource "azurerm_role_assignment" "this" {
  for_each = var.rbac_role_assignments

  scope                            = each.value.scope == "storage_account" ? local.storage_account_id : azurerm_storage_container.this[each.value.scope].resource_manager_id
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_id
  principal_id                     = each.value.principal_id
  principal_type                   = each.value.principal_type
  condition                        = each.value.condition
  condition_version                = each.value.condition_version
  description                      = each.value.description
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}
