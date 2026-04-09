variable "name_prefix" {
  description = "Prefix used for naming all resources."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}

variable "aks_subnet_cidr" {
  description = "CIDR block for the AKS nodes subnet."
  type        = string
}

variable "internal_lb_subnet_cidr" {
  description = "CIDR block for the internal load balancer subnet."
  type        = string
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoints subnet."
  type        = string
}
