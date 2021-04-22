output "virtual_machine_ids" {
  value = azurerm_linux_virtual_machine.cluster[*].id
}

output "virtual_machine_names" {
  value = azurerm_linux_virtual_machine.cluster[*].name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.resource_group.name
}