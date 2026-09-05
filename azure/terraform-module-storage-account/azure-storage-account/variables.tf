variable "storage_account_name" {
  description = "The globally unique name of the storage account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must be 3 to 24 characters and contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the storage account exists."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the storage account."
  type        = string
}

variable "storage_account_create" {
  description = "Controls whether to create a storage account or query an existing one."
  type        = bool
  default     = true
}

variable "account_kind" {
  description = "The kind of storage account."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "account_kind must be one of BlobStorage, BlockBlobStorage, FileStorage, Storage, or StorageV2."
  }
}

variable "account_tier" {
  description = "The performance tier of the storage account."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Premium", "Standard"], var.account_tier)
    error_message = "account_tier must be Premium or Standard."
  }
}

variable "account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
  default     = "GRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "access_tier" {
  description = "The access tier for BlobStorage, FileStorage, and StorageV2 accounts."
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Cold", "Cool", "Hot", "Premium", "Smart"], var.access_tier)
    error_message = "access_tier must be one of Cold, Cool, Hot, Premium, or Smart."
  }
}

variable "https_traffic_only_enabled" {
  description = "Whether the storage account should require HTTPS traffic."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum TLS version supported by the storage account."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "min_tls_version must be TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "Whether containers and blobs can opt into public access."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Whether authorization using storage account access keys and account SAS tokens is enabled."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access to the storage account is enabled."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "Whether the Azure portal defaults to Microsoft Entra ID authentication."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Whether Hierarchical Namespace is enabled."
  type        = bool
  default     = false
}

variable "infrastructure_encryption_enabled" {
  description = "Whether to enable an additional infrastructure encryption layer."
  type        = bool
  default     = true
}

variable "network_rules" {
  description = "Network access rules for the storage account. Secure defaults deny public traffic."
  type = object({
    default_action             = optional(string, "Deny")
    bypass                     = optional(set(string), ["AzureServices"])
    ip_rules                   = optional(set(string), [])
    virtual_network_subnet_ids = optional(set(string), [])
  })
  default = {}

  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules.default_action)
    error_message = "network_rules.default_action must be Allow or Deny."
  }

  validation {
    condition = alltrue([
      for bypass in var.network_rules.bypass :
      contains(["Logging", "Metrics", "AzureServices", "None"], bypass)
    ])
    error_message = "network_rules.bypass entries must be Logging, Metrics, AzureServices, or None."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the storage account."
  type        = map(string)
  default     = null
}

variable "containers" {
  description = "Blob containers to create, keyed by a stable Terraform identifier."
  type = map(object({
    container_access_type             = optional(string, "private")
    default_encryption_scope          = optional(string)
    encryption_scope_override_enabled = optional(bool, true)
    metadata                          = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for container in values(var.containers) :
      contains(["blob", "container", "private"], container.container_access_type)
    ])
    error_message = "Each container_access_type must be blob, container, or private."
  }
}

variable "sas_policy" {
  description = "Optional policy controlling the expiration and handling of SAS tokens."
  type = object({
    expiration_period = string
    expiration_action = optional(string, "Log")
  })
  default = null

  validation {
    condition = var.sas_policy == null ? true : contains(
      ["Block", "Log"],
      var.sas_policy.expiration_action
    )
    error_message = "sas_policy.expiration_action must be Block or Log."
  }
}

variable "sas" {
  description = "Optional account SAS token configuration. The resulting token is exposed as a sensitive output."
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
    condition = var.sas == null ? true : (
      var.sas.start != "" &&
      var.sas.expiry != "" &&
      var.sas.start != var.sas.expiry
    )
    error_message = "sas.start and sas.expiry must be non-empty and different ISO-8601 timestamps."
  }
}

variable "role_assignments" {
  description = "Optional RBAC assignments. Set scope for an arbitrary scope or container_name for a managed container scope."
  type = map(object({
    principal_id                     = string
    role_definition_id               = optional(string)
    role_definition_name             = optional(string)
    principal_type                   = optional(string)
    scope                            = optional(string)
    container_name                   = optional(string)
    condition                        = optional(string)
    condition_version                = optional(string)
    description                      = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      (assignment.role_definition_id != null) != (assignment.role_definition_name != null)
    ])
    error_message = "Each role assignment must set exactly one of role_definition_id or role_definition_name."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      !(assignment.scope != null && assignment.container_name != null)
    ])
    error_message = "Each role assignment can set scope or container_name, but not both."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      assignment.principal_type == null || contains(
        ["Group", "ServicePrincipal", "User"],
        assignment.principal_type
      )
    ])
    error_message = "principal_type must be Group, ServicePrincipal, or User when specified."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      assignment.condition_version == null || contains(["1.0", "2.0"], assignment.condition_version)
    ])
    error_message = "condition_version must be 1.0 or 2.0 when specified."
  }
}
