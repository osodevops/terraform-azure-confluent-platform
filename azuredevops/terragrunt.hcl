remote_state {
  backend = "azurerm"
  config = {
    key = "azuredevops/terraform.tfstate"
    resource_group_name = "terraform-state"
    storage_account_name = "confluentstate"
    container_name = "tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
