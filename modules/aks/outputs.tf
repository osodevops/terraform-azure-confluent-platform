output "cluster_id" {
  description = "The resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.id
}

output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  description = "The private FQDN of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.private_fqdn
}

output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "kube_admin_config" {
  description = "Raw admin kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.kube_admin_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet managed identity."
  value       = azurerm_user_assigned_identity.kubelet.principal_id
}

output "kubelet_identity_client_id" {
  description = "The client ID of the kubelet managed identity."
  value       = azurerm_user_assigned_identity.kubelet.client_id
}

output "node_resource_group" {
  description = "The auto-generated resource group for AKS node resources."
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}
