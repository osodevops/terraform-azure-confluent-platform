variable "prefix" {
  description = "The prefix used for all resources in this example"
}
variable "environment" {
  description = "The environment used to identify resources in this example"
}
variable "location" {
  description = "The Azure location where all resources in this example should be created"
}
variable "private_subnet_name" {
  description = "Identifier for the private subnet"
}
variable "public_subnet_name" {
  description = "Identifier for the public subnet"
}
variable "cp-ansible-version" {
  description = "The version of cp-ansible to deploy"
  default = "6.1.1-post"
}
locals {
  uid = "${var.prefix}-${var.environment}"
}