module "connect" {
  source = "../modules/confluent_node"
  application = "connect"
  user_data_template = "default"
  admin_username = "osoadmin"
  cluster_instance_count = 1
  data_disk_size = 0
  environment = "sandbox"
  dns_zone = var.dns_zone
  azure_resource_group_name = data.terraform_remote_state.shared.outputs.resource-group-name
  azure_virtual_network_name = data.terraform_remote_state.shared.outputs.virtual-network-name
  azure_subnet_name = var.private_subnet_name
  common_tags = local.common_tags
}
