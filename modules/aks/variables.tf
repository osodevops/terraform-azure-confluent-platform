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
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create resources."
  type        = string
}

variable "aks_subnet_id" {
  description = "Resource ID of the subnet for AKS nodes."
  type        = string
}

variable "private_dns_zone_id" {
  description = "Resource ID of the private DNS zone for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.30"
}

variable "sku_tier" {
  description = "SKU tier for the AKS cluster (Free, Standard, or Premium)."
  type        = string
  default     = "Standard"
}

variable "system_node_pool" {
  description = "Configuration for the system node pool."
  type = object({
    vm_size    = string
    node_count = number
    os_disk_gb = number
  })
}

variable "confluent_node_pool" {
  description = "Configuration for the Confluent workload node pool."
  type = object({
    vm_size    = string
    min_count  = number
    max_count  = number
    os_disk_gb = number
    disk_type  = string
  })
}

variable "authorized_ip_ranges" {
  description = "List of authorized IP ranges for the AKS API server."
  type        = list(string)
  default     = []
}
