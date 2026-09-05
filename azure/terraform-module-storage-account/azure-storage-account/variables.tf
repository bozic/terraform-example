variable "storage_account_name" {
  description = "The name of the Storage Account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3 to 24 characters and contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Storage Account exists."
  type        = string
}

variable "location" {
  description = "The Azure region for a Storage Account being created."
  type        = string
}

variable "storage_account_create" {
  description = "Controls whether to create a Storage Account or query an existing one."
  type        = bool
  default     = true
}

variable "account_kind" {
  description = "The kind of Storage Account to create."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "account_kind must be one of BlobStorage, BlockBlobStorage, FileStorage, Storage, or StorageV2."
  }
}

variable "account_tier" {
  description = "The performance tier of the Storage Account."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "The replication type of the Storage Account."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "access_tier" {
  description = "The access tier for BlobStorage, FileStorage, or StorageV2 accounts."
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool", "Cold", "Premium"], var.access_tier)
    error_message = "access_tier must be Hot, Cool, Cold, or Premium."
  }
}

variable "https_traffic_only_enabled" {
  description = "Forces HTTPS traffic to the Storage Account when true."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum TLS version supported by the Storage Account."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "min_tls_version must be TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "Allows nested items to opt into public access when true."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Allows Shared Key authorization for the Storage Account when true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Controls whether public network access to the Storage Account is enabled."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "Uses Azure AD authorization by default in the Azure portal when true."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Enables Hierarchical Namespace for Data Lake Storage Gen2."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the Storage Account."
  type        = map(string)
  default     = null
}

variable "containers" {
  description = "Blob containers to create, keyed by container name."
  type = map(object({
    container_access_type             = optional(string, "private")
    default_encryption_scope          = optional(string)
    encryption_scope_override_enabled = optional(bool, true)
    metadata                          = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, container in var.containers :
      can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])?$", name)) &&
      !can(regex("--", name)) &&
      contains(["blob", "container", "private"], container.container_access_type)
    ])
    error_message = "Container names must be 3 to 63 lowercase letters, numbers, or single hyphens, and container_access_type must be blob, container, or private."
  }
}

variable "sas" {
  description = "Optional account SAS configuration. The resulting SAS token is exposed through the sas output."
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
}

variable "rbac_role_assignments" {
  description = "RBAC assignments keyed by a stable caller-defined key. Scope is storage_account or a container name."
  type = map(object({
    principal_id                     = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    scope                            = optional(string, "storage_account")
    principal_type                   = optional(string)
    condition                        = optional(string)
    condition_version                = optional(string)
    description                      = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.rbac_role_assignments) :
      (assignment.role_definition_name != null) != (assignment.role_definition_id != null) &&
      (assignment.condition == null) == (assignment.condition_version == null) &&
      (assignment.principal_type == null || contains(["User", "Group", "ServicePrincipal"], assignment.principal_type)) &&
      (assignment.condition_version == null || contains(["1.0", "2.0"], assignment.condition_version))
    ])
    error_message = "Each RBAC assignment must set exactly one role_definition_name or role_definition_id; condition and condition_version must be set together; principal_type and condition_version must use supported values."
  }
}
