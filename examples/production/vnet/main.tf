terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.55.0"
    }
  }

  # Partial configuration for the backend: https://www.terraform.io/docs/backends/config.html
  backend "azurerm" {
  }
}