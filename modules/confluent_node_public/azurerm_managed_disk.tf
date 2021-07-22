resource azurerm_managed_disk cluster_data_disk_01 {
  count = var.data_disk_size > 0 ? var.cluster_instance_count : 0

  name = "${azurerm_linux_virtual_machine.cluster[count.index].name}-disk-02"
  resource_group_name = azurerm_linux_virtual_machine.cluster[count.index].resource_group_name
  location = data.azurerm_resource_group.resource_group.location
  create_option = "Empty"
  storage_account_type = var.data_disk_type
  disk_size_gb = var.data_disk_size
  tags = var.common_tags
}

resource azurerm_virtual_machine_data_disk_attachment cluster_data_disk_01_attachment {
  count = var.data_disk_size > 0 ? var.cluster_instance_count : 0

  managed_disk_id = azurerm_managed_disk.cluster_data_disk_01[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.cluster[count.index].id
  caching = "ReadWrite"
  lun = var.data_disk_attachment_lun_id
}