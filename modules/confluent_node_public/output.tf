output virtual_machine_name {
  value = azurerm_linux_virtual_machine.cluster[*].name
}
output public_ip_address {
  value = azurerm_public_ip.node-ip.ip_address
}
output security_group {
  value = azurerm_network_security_group.node.name
}