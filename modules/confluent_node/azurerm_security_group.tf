
resource "azurerm_network_security_group" "node" {
  name                = "${local.uid}-sg"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.common_tags
}

resource "azurerm_network_interface_security_group_association" "nic-association" {
  count = var.cluster_instance_count
  network_interface_id          = azurerm_network_interface.cluster_interface[count.index].id
  network_security_group_id     = azurerm_network_security_group.node.id
}