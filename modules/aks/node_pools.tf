resource "azurerm_kubernetes_cluster_node_pool" "confluent" {
  name                  = "confluent"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.confluent_node_pool.vm_size
  os_disk_size_gb       = var.confluent_node_pool.os_disk_gb
  os_disk_type          = var.confluent_node_pool.disk_type
  vnet_subnet_id        = var.aks_subnet_id
  zones                 = ["1", "2", "3"]
  auto_scaling_enabled  = true
  min_count             = var.confluent_node_pool.min_count
  max_count             = var.confluent_node_pool.max_count
  node_taints           = ["confluent.io/workload=true:NoSchedule"]
  node_labels           = { "confluent.io/workload" = "true" }
  tags                  = var.tags
}
