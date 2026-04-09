variable "operator_version" {
  type        = string
  description = "Helm chart version for the CFK operator"
  default     = "0.1033.3"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace to deploy the operator into"
  default     = "confluent"
}

variable "namespaced" {
  type        = bool
  description = "Deploy in namespaced mode (true) or cluster-wide (false)"
  default     = true
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it doesn't exist"
  default     = false
}

variable "tolerations" {
  type = list(object({
    key      = string
    operator = string
    value    = string
    effect   = string
  }))
  default = []
}

variable "resource_requests" {
  type = object({
    cpu    = optional(string, "500m")
    memory = optional(string, "512Mi")
  })
  default = {}
}

variable "resource_limits" {
  type = object({
    cpu    = optional(string, "1")
    memory = optional(string, "1Gi")
  })
  default = {}
}
