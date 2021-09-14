module rest_proxy {
  source = "../../modules/confluent_node_public"
  application = "rest-proxy"
  user_data_template = "default"
  admin_username = "osoadmin"
  cluster_instance_count = 1
  data_disk_size = 0
  environment = "sandbox"
  dns_zone = var.dns_zone
  azure_resource_group_name = data.terraform_remote_state.shared.outputs.resource_group_name
  azure_virtual_network_name = data.terraform_remote_state.shared.outputs.virtual_network_name
  azure_subnet_name = var.private_subnet_name
  common_tags = local.common_tags
}

output rest-proxy-ip {
  value = module.rest_proxy.public_ip_address
}


resource azurerm_network_security_rule rest_proxy {
  name                       = "rest-proxy"
  priority                   = 200
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges     = ["8082"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = data.terraform_remote_state.shared.outputs.resource_group_name
  network_security_group_name = module.rest_proxy.security_group
}