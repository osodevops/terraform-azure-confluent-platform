# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = local.create_networking ? module.networking[0].resource_group_name : data.azurerm_subnet.existing[0].resource_group_name
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = local.create_networking ? module.networking[0].vnet_id : null
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = local.create_networking ? module.networking[0].vnet_name : null
}

# ---------------------------------------------------------------------------------------------------------------------
# AKS
# ---------------------------------------------------------------------------------------------------------------------

output "aks_cluster_id" {
  description = "ID of the AKS cluster."
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster."
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "Private FQDN of the AKS cluster."
  value       = module.aks.cluster_fqdn
}

output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL of the AKS cluster."
  value       = module.aks.oidc_issuer_url
}

output "kube_config" {
  description = "Kubeconfig for the AKS cluster."
  value       = module.aks.kube_config
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFLUENT PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

output "confluent_namespace" {
  description = "Kubernetes namespace where Confluent Platform is deployed."
  value       = module.security.confluent_namespace
}

output "kafka_bootstrap_endpoint" {
  description = "Internal Kafka bootstrap endpoint."
  value       = module.confluent_platform.kafka_bootstrap_endpoint
}

output "schema_registry_endpoint" {
  description = "Internal Schema Registry endpoint."
  value       = module.confluent_platform.schema_registry_endpoint
}

output "connect_endpoint" {
  description = "Internal Kafka Connect endpoint."
  value       = module.confluent_platform.connect_endpoint
}

output "ksqldb_endpoint" {
  description = "Internal ksqlDB endpoint."
  value       = module.confluent_platform.ksqldb_endpoint
}

output "control_center_endpoint" {
  description = "Internal Control Center endpoint."
  value       = module.confluent_platform.control_center_endpoint
}

output "kafka_rest_proxy_endpoint" {
  description = "Internal Kafka REST Proxy endpoint."
  value       = module.confluent_platform.kafka_rest_proxy_endpoint
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY
# ---------------------------------------------------------------------------------------------------------------------

output "key_vault_id" {
  description = "ID of the Azure Key Vault."
  value       = module.security.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault."
  value       = module.security.key_vault_uri
}
