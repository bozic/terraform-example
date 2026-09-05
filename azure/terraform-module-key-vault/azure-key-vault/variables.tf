variable "name" {
  description = "The globally unique name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault should exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID used to authenticate requests to the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Key Vault."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either standard or premium."
  }
}

variable "key_vault_create" {
  description = "Controls whether to create a new Key Vault or query an existing one."
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  description = "Whether Azure Virtual Machines can retrieve certificates stored as secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Whether Azure Disk Encryption can retrieve secrets and unwrap keys from the Key Vault."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Whether Azure Resource Manager can retrieve secrets from the Key Vault."
  type        = bool
  default     = false
}

variable "rbac_authorization_enabled" {
  description = "Whether the Key Vault uses Azure role-based access control for data-plane authorization."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the Key Vault."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "The number of days deleted Key Vault items are retained."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "network_acls" {
  description = "Network ACL configuration for the Key Vault. Unmatched traffic is always denied."
  type = object({
    bypass                     = optional(string, "AzureServices")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}

  validation {
    condition     = contains(["AzureServices", "None"], var.network_acls.bypass)
    error_message = "network_acls.bypass must be either AzureServices or None."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the Key Vault."
  type        = map(string)
  default     = null
}
