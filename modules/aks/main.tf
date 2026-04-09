resource "azurerm_kubernetes_cluster" "main" {
  name                      = "${var.name_prefix}-aks"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.name_prefix
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = true
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  sku_tier                  = var.sku_tier
  private_dns_zone_id       = var.private_dns_zone_id
  tags                      = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = var.system_node_pool.vm_size
    node_count                   = var.system_node_pool.node_count
    os_disk_size_gb              = var.system_node_pool.os_disk_gb
    vnet_subnet_id               = var.aks_subnet_id
    zones                        = ["1", "2", "3"]
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "systemtemp"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
    service_cidr        = "172.16.0.0/16"
    dns_service_ip      = "172.16.0.10"
    pod_cidr            = "192.168.0.0/16"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges
  }

  depends_on = [
    azurerm_role_assignment.kubelet_network_contributor,
    azurerm_role_assignment.aks_private_dns_zone_contributor,
    azurerm_role_assignment.aks_managed_identity_operator,
  ]
}
