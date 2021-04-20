variable "prefix" {
  description = "The prefix used for all resources in this example"
}
variable "environment" {
  description = "The environment used to identify resources in this example"
}
variable "location" {
  description = "The Azure location where all resources in this example should be created"
}
variable "internal_subnet_name" {
  description = "Identifier for the internal subnet"
}
locals {
  uid = "${var.prefix}-${var.environment}"
}