variable "confluent_namespace" {
  description = "Namespace where Confluent Platform is deployed."
  type        = string
}

variable "prometheus_namespace" {
  description = "Namespace where Prometheus is deployed."
  type        = string
  default     = "monitoring"
}

variable "component_flags" {
  description = "Map of component names to enabled status."
  type        = map(bool)
}
