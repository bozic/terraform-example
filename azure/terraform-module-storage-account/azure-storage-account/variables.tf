variable "storage_account_name" {
  description = "The name of the Storage Account. Must be globally unique, lowercase alphanumeric."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Storage Account should exist."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Storage Account should exist."
  type        = string
}

variable "storage_account_create" {
  description = "Controls whether to create a new Storage Account or query an existing one."
  type        = bool
  default     = true
}

variable "account_kind" {
  description = "The Kind of Storage Account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`."
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "The Tier to use for the Storage Account. Valid options are `Standard` and `Premium`."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The type of replication to use for the Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "The access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot`, `Cool`, `Cold`, `Smart` and `Premium`."
  type        = string
  default     = "Hot"
}

variable "https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the Storage Account. Possible values are `TLS1_0`, `TLS1_1` and `TLS1_2`."
  type        = string
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within the Storage Account to opt into being public."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. Must be `true` to use Shared Access Signature (SAS) tokens."
  type        = bool
  default     = true
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? Used with Azure Data Lake Storage Gen 2."
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "A `network_rules` block to restrict network access to the Storage Account. Defaults to denying public network access except for trusted Azure services; set `ip_rules` and/or `virtual_network_subnet_ids` to allow specific networks, or set `default_action = \"Allow\"` to permit all traffic."
  type = object({
    default_action             = string
    bypass                     = optional(list(string))
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  validation {
    condition     = var.network_rules == null || contains(["Allow", "Deny"], var.network_rules.default_action)
    error_message = "network_rules.default_action must be either 'Allow' or 'Deny'."
  }
}

variable "identity" {
  description = "An `identity` block to configure a Managed Service Identity for the Storage Account."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "identity.type must be one of 'SystemAssigned', 'UserAssigned' or 'SystemAssigned, UserAssigned'."
  }

  validation {
    condition     = var.identity == null || !contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type) || length(coalesce(var.identity.identity_ids, [])) > 0
    error_message = "identity.identity_ids must be set when identity.type is 'UserAssigned' or 'SystemAssigned, UserAssigned'."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the Storage Account."
  type        = map(string)
  default     = null
}

variable "containers" {
  description = "A map of Storage Containers to create within the Storage Account. The map key is used as the container name unless `name` is set."
  type = map(object({
    name                  = optional(string)
    container_access_type = optional(string, "private")
    metadata              = optional(map(string))
  }))
  default = {}

  validation {
    condition     = alltrue([for c in var.containers : contains(["blob", "container", "private"], c.container_access_type)])
    error_message = "containers.*.container_access_type must be one of 'blob', 'container' or 'private'."
  }
}

variable "role_assignments" {
  description = "A map of RBAC Role Assignments to create against the Storage Account."
  type = map(object({
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    principal_id                     = string
    principal_type                   = optional(string)
    description                      = optional(string)
    condition                        = optional(string)
    condition_version                = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for r in var.role_assignments : (r.role_definition_name != null) != (r.role_definition_id != null)
    ])
    error_message = "Each role_assignments entry must set exactly one of role_definition_name or role_definition_id."
  }

  validation {
    condition = alltrue([
      for r in var.role_assignments : r.condition_version == null || r.condition != null
    ])
    error_message = "condition is required when condition_version is set."
  }
}

variable "sas_token_enabled" {
  description = "Controls whether to generate a Shared Access Signature (SAS) token for the Storage Account."
  type        = bool
  default     = false

  validation {
    condition     = !var.sas_token_enabled || var.shared_access_key_enabled
    error_message = "shared_access_key_enabled must be true when sas_token_enabled is true."
  }
}

variable "sas" {
  description = "The configuration for the Shared Access Signature (SAS) token. Required when `sas_token_enabled` is `true`."
  type = object({
    https_only     = optional(bool, true)
    ip_addresses   = optional(string)
    signed_version = optional(string, "2022-11-02")
    start          = string
    expiry         = string
    resource_types = object({
      service   = bool
      container = bool
      object    = bool
    })
    services = object({
      blob  = bool
      queue = bool
      table = bool
      file  = bool
    })
    permissions = object({
      read    = bool
      write   = bool
      delete  = bool
      list    = bool
      add     = bool
      create  = bool
      update  = bool
      process = bool
      tag     = bool
      filter  = bool
    })
  })
  default = null

  validation {
    condition     = !var.sas_token_enabled || var.sas != null
    error_message = "sas must be set when sas_token_enabled is true."
  }
}
