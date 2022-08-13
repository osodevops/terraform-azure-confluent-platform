terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
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
    resource_group_name  = "terraform-tfstate"
    storage_account_name = "confluentstate"
  }
}