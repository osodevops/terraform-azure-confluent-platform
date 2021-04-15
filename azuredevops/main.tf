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


resource "azuredevops_variable_group" "ansible-vars" {
  project_id   = azuredevops_project.project.id
  name         = "oso_confluent_vars"
  allow_access = true

  variable {
    name  = "ANSIBLE_SSH_PUB"
    value = file("${path.module}/oso-confluent-ssh.pub")
    is_secret = false
  }
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "Sample GithHub Personal Access Token"
  auth_personal {
    # set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
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
    azuredevops_variable_group.ansible-vars.id
  ]
}

// This will be used for the cp-ansible provisioning
resource "azuredevops_build_definition" "github-terraform" {
  project_id = azuredevops_project.project.id
  name       = "Terraform Provisioning"
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
    azuredevops_variable_group.ansible-vars.id
  ]
}

// This will be used for the cp-ansible provisioning
resource "azuredevops_build_definition" "github-ansible" {
  project_id = azuredevops_project.project.id
  name       = "Ansible Provisioning"
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
    azuredevops_variable_group.ansible-vars.id
  ]
}
