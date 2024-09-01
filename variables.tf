variable "maintenance_configuration_name" {
  type = string
  description = "The name of  the maintenance configuration"
}

variable "maintenance_configuration_location" {
  type = string
  description = "The location of the maintenance configuration"
}

variable "maintenance_configuration_resource_group" {
  type = string
  description = "The resource group of the maintenance configuration"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}
