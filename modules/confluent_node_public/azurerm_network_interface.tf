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
    public_ip_address_id = azurerm_public_ip.node-ip.id
  }
  tags = var.common_tags
}


resource "azurerm_private_dns_a_record" "node" {
  count = var.cluster_instance_count
  name                = "${var.application}-${count.index + 1}"
  resource_group_name = var.azure_resource_group_name
  zone_name           = var.dns_zone
  ttl                 = 300
  records             = [
    azurerm_linux_virtual_machine.cluster[count.index].private_ip_address
  ]
  depends_on = [azurerm_linux_virtual_machine.cluster]
}

resource "azurerm_public_ip" "node-ip" {
  name                = local.uid
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

data "azurerm_network_security_group" "node" {
  name                = var.azure_subnet_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_network_interface_security_group_association" "nic-association" {
  count = var.cluster_instance_count
  network_interface_id          = azurerm_network_interface.cluster_interface[count.index].id
  network_security_group_id = data.azurerm_network_security_group.node.id
}