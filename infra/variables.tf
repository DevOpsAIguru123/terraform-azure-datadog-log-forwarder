variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  default = "datadog-log-forwarder-rg"
  type = string
}

variable "location" {
  description = "The location/region where the resources will be created."
  default = "West Europe"
  type = string  
}

variable "datadog_api_key" {
  description = "The Datadog API key."
  type = string
  sensitive = true   
}
