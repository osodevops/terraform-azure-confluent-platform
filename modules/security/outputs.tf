output "key_vault_id" {
  description = "The resource ID of the Azure Key Vault."
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "The URI of the Azure Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}

output "confluent_namespace" {
  description = "The name of the Kubernetes namespace for Confluent Platform."
  value       = kubernetes_namespace.confluent.metadata[0].name
}

output "mds_token_secret_name" {
  description = "The name of the Kubernetes secret containing MDS token keys, or null if RBAC is disabled."
  value       = var.rbac_enabled ? kubernetes_secret.mds_token[0].metadata[0].name : null
}

output "cert_manager_identity_client_id" {
  description = "The client ID of the cert-manager managed identity for workload identity."
  value       = azurerm_user_assigned_identity.cert_manager.client_id
}
