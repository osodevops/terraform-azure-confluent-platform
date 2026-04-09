variable "namespace" {
  description = "Kubernetes namespace where Confluent Platform components will be deployed."
  type        = string
}

variable "confluent_platform_version" {
  description = "Version of Confluent Platform to deploy."
  type        = string
  default     = "7.7.1"
}

variable "kraft_controller" {
  description = "Configuration for the KRaft controller cluster."
  type = object({
    replicas      = optional(number, 3)
    storage_size  = optional(string, "50Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "kafka" {
  description = "Configuration for the Kafka broker cluster."
  type = object({
    replicas      = optional(number, 3)
    storage_size  = optional(string, "500Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "schema_registry" {
  description = "Configuration for Schema Registry."
  type = object({
    enabled  = optional(bool, true)
    replicas = optional(number, 2)
  })
  default = {}
}

variable "connect" {
  description = "Configuration for Kafka Connect."
  type = object({
    enabled  = optional(bool, false)
    replicas = optional(number, 2)
  })
  default = {}
}

variable "ksqldb" {
  description = "Configuration for ksqlDB."
  type = object({
    enabled       = optional(bool, false)
    replicas      = optional(number, 2)
    storage_size  = optional(string, "100Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "control_center" {
  description = "Configuration for Confluent Control Center."
  type = object({
    enabled       = optional(bool, true)
    replicas      = optional(number, 1)
    storage_size  = optional(string, "50Gi")
    storage_class = optional(string, "managed-premium")
  })
  default = {}
}

variable "kafka_rest_proxy" {
  description = "Configuration for Kafka REST Proxy."
  type = object({
    enabled  = optional(bool, false)
    replicas = optional(number, 2)
  })
  default = {}
}

variable "tls_auto_generated" {
  description = "Whether to use auto-generated TLS certificates."
  type        = bool
  default     = true
}

variable "tls_custom_ca_secret" {
  description = "Name of the Kubernetes secret containing a custom CA for TLS. Used when tls_auto_generated is false."
  type        = string
  default     = null
}

variable "rbac_enabled" {
  description = "Whether to enable RBAC authorization via MDS."
  type        = bool
  default     = true
}

variable "mds_super_users" {
  description = "List of super users for MDS/RBAC authorization."
  type        = list(string)
  default     = ["kafka"]
}

variable "mds_token_secret" {
  description = "Name of the Kubernetes secret containing the MDS token key pair."
  type        = string
  default     = null
}
