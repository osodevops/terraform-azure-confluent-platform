terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.55.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    container_name       = "tfstate"
    key                  = "sandbox/terraform.shared.tfstate"
    resource_group_name  = "terraform-state"
    storage_account_name = "confluentstate"
  }
}