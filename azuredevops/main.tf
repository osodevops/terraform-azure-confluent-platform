# Make sure to set the following environment variables:
#   AZDO_PERSONAL_ACCESS_TOKEN=
#   AZDO_ORG_SERVICE_URL=https://dev.azure.com/osodevops
#   AZDO_GITHUB_SERVICE_CONNECTION_PAT
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

resource "azuredevops_project" "project" {
  name               = "OSO Confluent"
  description        = "An OSO implementation of Confluent provisioned by cp-ansible"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
    "testplans" = "disabled"
    "artifacts" = "disabled"
    "boards" = "disabled"
    "repositories" = "disabled"
  }
}

resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Sample GithHub Personal Access Token"
  auth_personal {
    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
    personal_access_token = var.pat-token
  }
}

// Self referencing pipeline for changes to the Azure Devops Project
resource "azuredevops_build_definition" "github-azure-devops" {
  project_id = azuredevops_project.project.id
  name       = "Azure Devops Provisioning"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "GitHub"
    repo_id     = "osodevops/azure-terraform-module-confluent"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    branch_name = "main"
    yml_path    = "azure-devops-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]
}

// This will be used for the cp-ansible provisioning
resource "azuredevops_build_definition" "github-terraform" {
  project_id = azuredevops_project.project.id
  name       = "Confluent Terraform Provisioning"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "GitHub"
    repo_id     = "osodevops/azure-terraform-module-confluent"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    branch_name = "main"
    yml_path    = "terraform-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]
}

// This will be used for the cp-ansible provisioning
resource "azuredevops_build_definition" "github-ansible" {
  project_id = azuredevops_project.project.id
  name       = "Confluent Ansible Provisioning"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "GitHub"
    repo_id     = "osodevops/azure-terraform-module-confluent"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    branch_name = "main"
    yml_path    = "ansible-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]
}