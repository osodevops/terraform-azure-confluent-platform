# Make sure to set the following environment variables:
#   AZDO_PERSONAL_ACCESS_TOKEN=
#   AZDO_ORG_SERVICE_URL=https://dev.azure.com/osodevops
terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

data "azuredevops_project" "project" {
  name       = "confluent"
}

resource "azuredevops_variable_group" "vars" {
  project_id   = data.azuredevops_project.project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_serviceendpoint_azurerm" "endpointazure" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "Sample AzureRM"
  description = "Managed by Terraform"
  credentials {
    serviceprincipalid  = "00000000-0000-0000-0000-000000000000"
    serviceprincipalkey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
  azurerm_spn_tenantid      = "00000000-0000-0000-0000-000000000000"
  azurerm_subscription_id   = "00000000-0000-0000-0000-000000000000"
  azurerm_subscription_name = "Sample Subscription"
}

resource "azuredevops_build_definition" "build" {
  project_id = data.azuredevops_project.project.id
  name       = "Confluent Terraform Build"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = "95c56fb0-1e8a-4be3-b5e1-29986504db08"
    branch_name = "develop"
    yml_path    = "build-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name      = "PipelineSecret"
    secret_value     = "ZGV2cw"
    is_secret = true
  }
}

resource "azuredevops_build_definition" "release" {
  project_id = data.azuredevops_project.project.id
  name       = "Confluent Terraform Release"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = "95c56fb0-1e8a-4be3-b5e1-29986504db08"
    branch_name = "develop"
    yml_path    = "release-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name      = "PipelineSecret"
    secret_value     = "ZGV2cw"
    is_secret = true
  }
}

resource "azuredevops_serviceendpoint_github" "serviceendpoint_gh_1" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "Sample GithHub Personal Access Token"

  auth_personal {
    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
    personal_access_token = ""
  }
}

// This will be used for the cp-ansible provisioning
resource "azuredevops_build_definition" "github" {
  project_id = data.azuredevops_project.project.id
  name       = "Confluent Terraform Release"
  path       = "\\Confluent"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "GitHub"
    repo_id     = "osodevops/azure-terraform-module-confluent"
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_gh_1.id
    branch_name = "develop"
    yml_path    = "build-pipeline.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name      = "PipelineSecret"
    secret_value     = "ZGV2cw"
    is_secret = true
  }
}
