terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.4.0"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = "1.3.1"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/example"
  personal_access_token = "exampletoken"
 }

resource "azuredevops_project" "example" {
  name               = "Example Project"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "example" {
  project_id = azuredevops_project.example.id
  name       = "Example Repository"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_build_definition" "example" {
  project_id = azuredevops_project.example.id
  name       = "Example Build Definition"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.example.id
    branch_name = azuredevops_git_repository.example.default_branch
    yml_path    = "azure-pipelines.yml"
  }
}

resource "azuredevops_environment" "example" {
  project_id = azuredevops_project.example.id
  name       = "Example Environment"
}

resource "azuredevops_serviceendpoint_azurerm" "example" {
  project_id                    = azuredevops_project.example.id
  service_endpoint_name         = "Example AzureRM"
  description                   = "Managed by Terraform"
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = "00000000-0000-0000-0000-000000000000"
    serviceprincipalkey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
  azurerm_spn_tenantid      = "00000000-0000-0000-0000-000000000000"
  azurerm_subscription_id   = "00000000-0000-0000-0000-000000000000"
  azurerm_subscription_name = "Example Subscription Name"
}

module "pipeline_permissions" {
  source = "../.."
  build_definition_id = azuredevops_build_definition.example.id
  devops_environment = azuredevops_environment.example
  devops_project_name = azuredevops_project.example.name
  devops_service_url = "https://dev.azure.com/example"
  personal_access_token = "exampletoken"
  service_connection_id = azuredevops_serviceendpoint_azurerm.example.id
}