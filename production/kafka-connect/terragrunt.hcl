
terraform {
  source = "../..//modules/confluent_node"
}

include {
  path = find_in_parent_folders()
}

dependency "resource-group" {
  config_path = "../resource-group"
  skip_outputs = "true"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  prefix = local.environment_vars.locals.prefix
  azure_location =  local.environment_vars.locals.azure_location
  azure_resource_group_name = "${local.environment_vars.locals.prefix}-${local.environment_vars.locals.environment}-resources"
  azure_virtual_network_name = "${local.environment_vars.locals.prefix}-${local.environment_vars.locals.environment}-network"
  internal_subnet_name = local.environment_vars.locals.internal_subnet_name
  common_tags = local.environment_vars.locals.common_tags
}

inputs = {
  application = "${basename(get_terragrunt_dir())}"
  admin_username = "osoadmin"
  cluster_instance_count = 1
  environment = local.env
  prefix = local.prefix
  azure_location = local.azure_location
  azure_resource_group_name = local.azure_resource_group_name
  azure_virtual_network_name = local.azure_virtual_network_name
  azure_subnet_name = local.internal_subnet_name
  common_tags = local.common_tags
}