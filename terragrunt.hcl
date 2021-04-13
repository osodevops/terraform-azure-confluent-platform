# Generate an AWS provider block
//TODO: Would like to get this to work for purposes of assuming roles/etc.
//generate "provider" {
//  path      = "../../modules/confluent_node/provider.tf"
//  if_exists = "overwrite_terragrunt"
//  contents  = <<EOF
//provider "azurerm" {
//    features {}
//}
//EOF
//}

remote_state {
  backend = "azurerm"
  config = {
    key = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name = "oso-confluent"
    storage_account_name = "osoconfluent"
    container_name = "tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
