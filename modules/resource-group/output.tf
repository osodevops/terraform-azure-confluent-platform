output "resource-group-name" {
  value = azurerm_resource_group.confluent.name
}
output "virtual-network-name" {
  value = azurerm_virtual_network.confluent.name
}
