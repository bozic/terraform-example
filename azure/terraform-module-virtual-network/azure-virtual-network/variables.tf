variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group that contains the Virtual Network."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Virtual Network should exist. Required when vnet_create is true."
  type        = string
  default     = null

  validation {
    condition     = !var.vnet_create || var.location != null
    error_message = "location must be provided when vnet_create is true."
  }
}

variable "vnet_create" {
  description = "Controls whether to create a new Virtual Network or query an existing one."
  type        = bool
  default     = true
}

variable "address_space" {
  description = "The address spaces that are used by the Virtual Network. Required when vnet_create is true."
  type        = list(string)
  default     = null

  validation {
    condition     = !var.vnet_create || var.address_space != null
    error_message = "address_space must be provided when vnet_create is true."
  }
}

variable "dns_servers" {
  description = "A list of DNS server IP addresses for the Virtual Network."
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Subnets to create, keyed by subnet name. Each subnet can reference a distinct Network Security Group and Route Table."
  type = map(object({
    address_prefixes                              = list(string)
    network_security_group_id                     = optional(string)
    route_table_id                                = optional(string)
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
  }))
  default = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the Virtual Network."
  type        = map(string)
  default     = null
}