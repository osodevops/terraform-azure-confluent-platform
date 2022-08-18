module control_center {
  source = "../../../modules/confluent_node_public"
  application = "control-center"
  user_data_template = "default"
  admin_username = var.vm_admin_password
  cluster_instance_count = var.control_center_instance_count
  data_disk_size = 0
  environment = "production"
  dns_zone = var.dns_zone
  azure_resource_group_name = data.terraform_remote_state.shared.outputs.resource_group_name
  azure_virtual_network_name = data.terraform_remote_state.shared.outputs.virtual_network_name
  azure_subnet_name = var.public_subnet_name
  common_tags = local.common_tags
}

output control_center_ip {
  value = module.control_center.public_ip_address
}

resource azurerm_network_security_rule control_centre {
  name                       = "control-centre"
  priority                   = 200
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges     = ["9021"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = data.terraform_remote_state.shared.outputs.resource_group_name
  network_security_group_name = module.control_center.security_group
}