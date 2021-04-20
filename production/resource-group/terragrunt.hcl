terraform {
  source = "../..//modules/resource-group"
}

include {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  prefix = local.environment_vars.locals.prefix
  env = local.environment_vars.locals.environment
  azure_location =  local.environment_vars.locals.azure_location
  internal_subnet_name =  local.environment_vars.locals.internal_subnet_name
}

inputs = {
  prefix = local.prefix
  environment = local.env
  location = local.azure_location
  internal_subnet_name = local.internal_subnet_name
}