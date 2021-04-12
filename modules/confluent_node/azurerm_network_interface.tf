resource azurerm_network_interface cluster_interface {
  count               = var.cluster_instance_count

  name = "${local.uid}-vm-${format("%02d", count.index + 1)}-nic-01"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  # Private DNS is set to auto register we do not need to add a label here.
  ip_configuration {
    name                          = "${local.uid}-ip-config"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.common_tags
}
