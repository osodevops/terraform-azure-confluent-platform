module schema_registry {
  source = "../../../modules/confluent_node"
  application = "schema-registry"
  user_data_template = "default"
  admin_username = "osoadmin"
  cluster_instance_count = var.schema_registry_instance_count
  data_disk_size = 0
  environment = "production"
  dns_zone = var.dns_zone
  azure_resource_group_name = data.terraform_remote_state.shared.outputs.resource_group_name
  azure_virtual_network_name = data.terraform_remote_state.shared.outputs.virtual_network_name
  azure_subnet_name = var.private_subnet_name
  common_tags = local.common_tags
}

