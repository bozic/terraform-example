variable "resource_group_name" {
  description = "The name of the Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Resource Group should exist."
  type        = string
}

variable "resource_group_create" {
  description = "Controls whether to create a new Resource Group or query an existing one."
  type        = bool
  default     = true
}

variable "managed_by" {
  description = "The ID of the resource or application that manages this Resource Group."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the Resource Group."
  type        = map(string)
  default     = null
}
