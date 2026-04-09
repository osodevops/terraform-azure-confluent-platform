# ---------------------------------------------------------------------------------------------------------------------
# GENERAL
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Project name used in all resource naming. Must be lowercase alphanumeric with hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.name))
    error_message = "Name must be lowercase alphanumeric with hyphens, 2-21 characters, starting with a letter."
  }
}

variable "environment" {
  description = "Environment identifier (e.g. production, staging, dev)."
  type        = string
  default     = "production"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "uksouth"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_cidr" {
  description = "CIDR block for the AKS node subnet."
  type        = string
  default     = "10.0.0.0/21"
}

variable "internal_lb_subnet_cidr" {
  description = "CIDR block for the internal load balancer subnet."
  type        = string
  default     = "10.0.8.0/24"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet."
  type        = string
  default     = "10.0.9.0/24"
}

variable "existing_vnet_id" {
  description = "ID of an existing VNet to use. If set, the networking module is skipped."
  type        = string
  default     = null
}

variable "existing_aks_subnet_id" {
  description = "ID of an existing subnet for AKS nodes. Required if existing_vnet_id is set."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# AKS
# ---------------------------------------------------------------------------------------------------------------------

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster."
  type        = string
  default     = "1.30"
}

variable "aks_sku_tier" {
  description = "AKS SKU tier. Use 'Standard' for SLA-backed production clusters."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_sku_tier)
    error_message = "AKS SKU tier must be Free, Standard, or Premium."
  }
}

variable "system_node_pool" {
  description = "Configuration for the AKS system node pool."
  type = object({
    vm_size    = optional(string, "Standard_D4s_v5")
    node_count = optional(number, 3)
    os_disk_gb = optional(number, 128)
  })
  default = {}
}

variable "confluent_node_pool" {
  description = "Configuration for the dedicated Confluent workload node pool."
  type = object({
    vm_size    = optional(string, "Standard_D16s_v5")
    min_count  = optional(number, 3)
    max_count  = optional(number, 12)
    os_disk_gb = optional(number, 128)
    disk_type  = optional(string, "Ephemeral")
  })
  default = {}
}

variable "aks_authorized_ip_ranges" {
  description = "CIDR ranges authorized to access the AKS API server. Only used when the cluster is not fully private."
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# CFK OPERATOR
# ---------------------------------------------------------------------------------------------------------------------

variable "cfk_operator_version" {
  description = "Helm chart version for the Confluent for Kubernetes operator."
  type        = string
  default     = "0.1033.3"
}

variable "cfk_namespace" {
  description = "Kubernetes namespace for Confluent Platform components."
  type        = string
  default     = "confluent"
}

variable "cfk_namespaced" {
  description = "Deploy CFK operator in namespaced mode (true) or cluster-wide mode (false)."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFLUENT PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

variable "confluent_platform_version" {
  description = "Confluent Platform version to deploy."
  type        = string
  default     = "7.7.1"
}

variable "kraft_controller" {
  description = "KRaft controller configuration."
  type = object({
    replicas      = optional(number, 3)
    storage_size  = optional(string, "50Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "kafka" {
  description = "Kafka broker configuration."
  type = object({
    replicas      = optional(number, 3)
    storage_size  = optional(string, "500Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "schema_registry" {
  description = "Schema Registry configuration."
  type = object({
    enabled  = optional(bool, true)
    replicas = optional(number, 2)
  })
  default = {}
}

variable "connect" {
  description = "Kafka Connect configuration."
  type = object({
    enabled  = optional(bool, false)
    replicas = optional(number, 2)
  })
  default = {}
}

variable "ksqldb" {
  description = "ksqlDB configuration."
  type = object({
    enabled       = optional(bool, false)
    replicas      = optional(number, 2)
    storage_size  = optional(string, "100Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "control_center" {
  description = "Confluent Control Center configuration."
  type = object({
    enabled       = optional(bool, true)
    replicas      = optional(number, 1)
    storage_size  = optional(string, "50Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "kafka_rest_proxy" {
  description = "Kafka REST Proxy configuration."
  type = object({
    enabled  = optional(bool, false)
    replicas = optional(number, 2)
  })
  default = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY
# ---------------------------------------------------------------------------------------------------------------------

variable "tls_auto_generated" {
  description = "Let CFK auto-generate TLS certificates. Set to false to provide your own via tls_custom_ca_secret."
  type        = bool
  default     = true
}

variable "tls_custom_ca_secret" {
  description = "Name of a Kubernetes secret containing a custom CA for TLS. Only used when tls_auto_generated is false."
  type        = string
  default     = null
}

variable "rbac_enabled" {
  description = "Enable Confluent RBAC via Metadata Service (MDS)."
  type        = bool
  default     = true
}

variable "mds_super_users" {
  description = "List of MDS super user principals."
  type        = list(string)
  default     = ["kafka"]
}

variable "sasl_mechanism" {
  description = "SASL mechanism for authentication. Options: PLAIN, SCRAM-SHA-512."
  type        = string
  default     = "PLAIN"

  validation {
    condition     = contains(["PLAIN", "SCRAM-SHA-512"], var.sasl_mechanism)
    error_message = "SASL mechanism must be PLAIN or SCRAM-SHA-512."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MONITORING
# ---------------------------------------------------------------------------------------------------------------------

variable "monitoring_enabled" {
  description = "Deploy Prometheus ServiceMonitors and Grafana dashboards for Confluent components."
  type        = bool
  default     = true
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus is deployed."
  type        = string
  default     = "monitoring"
}
