variable "prefix" {
  description = "A value for purpose of namespacing"
  default = "oso"
}
variable "environment" {
  description = "The environment for deployment"
  default = "sandbox"
}
variable "azure_location" {
  description = "The Azure region for deployment"
  default = "UK South"
}
variable "dns_zone" {
  description = "DNS Zone name"
  default = "confluent.internal"
}
variable "private_subnet_name" {
  description = "The private subnet name"
  default = "confluent-private"
}
variable "public_subnet_name" {
  description = "The public subnet name"
  default = "confluent-public"
}

locals {
  common_tags = {
    "Application" = "confluent"
    "Environment" = "production"
    "Parent Business" = "Shared IT core services",
    "Portfolio" = "Digital and Technology",
    "Service Offering" = "Enterprise Data Integration Service",
    "Service Line" = "Cloud Infrastructure and Platforms",
    "Service" = "Azure Storage"
    "Product" = "Enterprise Data Integration Service"
  }
}
