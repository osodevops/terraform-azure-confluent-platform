terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "sandbox/terraform.shared.tfstate"
    resource_group_name  = "terraform-state"
    storage_account_name = "confluentstate"
  }
}
