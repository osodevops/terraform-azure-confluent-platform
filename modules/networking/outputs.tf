output "resource_group_name" {
  description = "Name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "ID of the resource group."
  value       = azurerm_resource_group.this.id
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "aks_subnet_id" {
  description = "ID of the AKS nodes subnet."
  value       = azurerm_subnet.aks_nodes.id
}

output "internal_lb_subnet_id" {
  description = "ID of the internal load balancer subnet."
  value       = azurerm_subnet.internal_lb.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoints subnet."
  value       = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_id" {
  description = "ID of the Confluent private DNS zone."
  value       = azurerm_private_dns_zone.confluent.id
}

output "private_dns_zone_name" {
  description = "Name of the Confluent private DNS zone."
  value       = azurerm_private_dns_zone.confluent.name
}
