variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Virtual Network exists."
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Network exists."
  type        = string
}

variable "vnet_create" {
  description = "Controls whether to create a new Virtual Network or query an existing one."
  type        = bool
  default     = true
}

variable "address_space" {
  description = "The address spaces for the Virtual Network. Required when vnet_create is true."
  type        = list(string)
  default     = null
}

variable "dns_servers" {
  description = "The list of custom DNS server IP addresses for the Virtual Network."
  type        = list(string)
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "The flow timeout in minutes for the Virtual Network."
  type        = number
  default     = null

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "flow_timeout_in_minutes must be between 4 and 30 minutes."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the Virtual Network."
  type        = map(string)
  default     = null
}

variable "subnets" {
  description = "Standalone subnets to create, keyed by subnet name. Each subnet can use a different NSG and route table."
  type = map(object({
    address_prefixes          = list(string)
    network_security_group_id = optional(string)
    route_table_id            = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, subnet in var.subnets :
      length(trimspace(name)) > 0 && length(subnet.address_prefixes) > 0
    ])
    error_message = "Each subnet must have a non-empty name and at least one address prefix."
  }
}
