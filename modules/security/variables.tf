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

variable "resource_group_id" {
  description = "Resource ID of the resource group."
  type        = string
}

variable "aks_oidc_issuer_url" {
  description = "The OIDC issuer URL of the AKS cluster for workload identity federation."
  type        = string
}

variable "kubelet_identity_object_id" {
  description = "The object ID of the kubelet managed identity for Key Vault access."
  type        = string
}

variable "confluent_namespace" {
  description = "Kubernetes namespace for Confluent Platform components."
  type        = string
  default     = "confluent"
}

variable "tls_auto_generated" {
  description = "Whether to use auto-generated TLS certificates via cert-manager."
  type        = bool
  default     = true
}

variable "tls_custom_ca_secret" {
  description = "Name of a Kubernetes secret containing a custom CA for TLS. If null, a self-signed CA is used."
  type        = string
  default     = null
}

variable "rbac_enabled" {
  description = "Whether to enable RBAC with MDS token-based authentication."
  type        = bool
  default     = true
}

variable "mds_super_users" {
  description = "List of super users for the Metadata Service (MDS)."
  type        = list(string)
  default     = ["kafka"]
}

variable "component_flags" {
  description = "Map of component names to booleans indicating which Confluent components are enabled."
  type        = map(bool)
}
