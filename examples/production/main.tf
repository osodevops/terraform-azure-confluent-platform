terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.71.0"
    }
  }

  # Partial configuration for the backend: https://www.terraform.io/docs/backends/config.html
  backend "azurerm" {
  }
}
data terraform_remote_state shared {
  backend = "azurerm"
  config = {
    container_name       = "tfstate"
    key                  = "prod/shared.terraform.tfstate"
    resource_group_name  = "terraform-state"
    storage_account_name = "confluentstate"
  }
}