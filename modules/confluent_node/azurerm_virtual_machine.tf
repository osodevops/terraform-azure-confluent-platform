resource "azurerm_linux_virtual_machine" "cluster" {
  count = var.cluster_instance_count
  name = "${local.uid}-vm-${format("%02d", count.index + 1)}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  network_interface_ids = [
    element(azurerm_network_interface.cluster_interface.*.id, count.index)
  ]
  size = var.cluster_instance_type
  custom_data = base64encode(
    templatefile("${path.module}/${var.user_data_template}.yml.tpl",
      {
        disk_lun_id = var.data_disk_attachment_lun_id
    })
  )

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/oso-confluent-ssh.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }

  tags = merge({
    "ClusterBuilder:Name"      = "${local.uid}-${count.index}"
    "ClusterBuilder:NodeIndex" = count.index % var.cluster_instance_count
  }, var.common_tags)
}
