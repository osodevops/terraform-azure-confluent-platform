variable prefix {
  description = "A value for purpose of namespacing"
  default = "oso"
}
variable environment {
  description = "The environment for deployment"
  default = "production"
}
variable azure_location {
  description = "The Azure region for deployment"
  default = "UK South"
}
variable dns_zone {
  description = "DNS Zone name"
  default = "confluent.internal"
}
variable private_subnet_name {
  description = "The private subnet name"
  default = "confluent-private"
}
variable public_subnet_name {
  description = "The public subnet name"
  default = "confluent-public"
}
variable vm_admin_password {
  description = "The admin password for the VM"
  default = "osoadmin"
}

# Zookeeper
variable "zookeeper_instance_count" {
  description = "Number of instances of Zookeeper"
}

variable "zookeeper_data_disk_size" {
  description = "Size in GB of data disk"
  default = "2048"
}

# Kafka broker
variable "broker_instance_count" {
  description = "Number of instances of Kafka brokers"
}

variable "broker_data_disk_size" {
  description = "Size in GB of data disk"
  default = "2048"
}

# Schema Registry
variable "schema_registry_instance_count" {
  description = "Number of instances of Schema Registry"
}

# Control Center
variable "control_center_instance_count" {
  description = "Control center can only be deployed once"
  default = 1
}

# Kafka Connect
variable "connect_instance_count" {
  description = "Number of instances of Kafka Connect"
  default = 0
}

# Rest Proxy
variable "rest_proxy_instance_count" {
  description = "Number of instances of Kafka Rest Proxy"
  default = 0
}

# KSQL
variable "ksql_instance_count" {
  description = "Number of instances of KSQL DB"
  default = 0
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
