module broker {
  source = "../../../modules/confluent_node"
  application = "broker"
  user_data_template = "broker"
  admin_username = "osoadmin"
  cluster_instance_count = var.broker_instance_count
  data_disk_size = var.broker_data_disk_size
  environment = "production"
  dns_zone = var.dns_zone
  azure_resource_group_name = data.terraform_remote_state.shared.outputs.resource_group_name
  azure_virtual_network_name = data.terraform_remote_state.shared.outputs.virtual_network_name
  azure_subnet_name = var.private_subnet_name
  common_tags = local.common_tags
}

