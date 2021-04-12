variable admin_username {
  type        = string
  description = "admin username"
}
variable admin_password {
  type        = string
  description = "admin password"
}
variable azure_subnet_name {
  type        = string
  description = "Name of the Subnet to use for deploying VMs"
}
variable azure_virtual_network_name {
  type        = string
  description = "Name of the Azure Virtual Network to use"
}
variable azure_resource_group_name {
  type        = string
  description = "Name of the Azure Resource Group to use"
}
variable shared_resource_group_name {
  type        = string
  description = "Name of the Azure Resource Group to use"
  default = ""
}
variable environment {
  type        = string
  description = "Identifier for the environment. e.g. T (test) or P (prod)"
}
variable application {
  type        = string
  description = "Part of unique name tag - 'kafka' or 'zookeeper'"
}
variable cluster_instance_count {
  type        = number
  description = "Number of instances to deploy"
  default     = 1
}
variable cluster_instance_type {
  type        = string
  description = "VM size"
  default     = "Standard_D8as_v4"
}
variable "root_disk_size" {
  type    = number
  default = 64
}
variable data_disk_size {
  type        = number
  description = "Size, in GB, of data disk(s)"
  default     = 0
}
variable data_disk_type {
  type        = string
  description = "Type of data disk(s)"
  default     = "StandardSSD_LRS"
}
variable data_disk_attachment_lun_id {
  type        = number
  default     = 10
}
variable common_tags {
  type        = map(string)
  description = "Common set of tags to apply to all resources created by the modules"
  default     = {}
}
variable "user_data_template" {
  description = "The user_data template to use on cloud init"
  default = "default"
}
locals {
  uid = "${var.environment}-${var.application}"
}