remote_state {
  backend = "azurerm"
  config = {
    key = "azuredevops/terraform.tfstate"
    resource_group_name = "oso-confluent"
    storage_account_name = "osoconfluent"
    container_name = "tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
