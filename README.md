# Pipeline Permissions for Azure DevOps
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-module-template.svg)](https://registry.terraform.io/modules/qbeyond/terraform-module-template/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-module-template.svg)](https://github.com/qbeyond/terraform-module-template/blob/main/LICENSE)

----

## Introduction
This Module will create the needed pipeline permissions, so the pipeline can be used afterwards without additional manual configuration. 

  - A given DevOps team or the projects default team will get the permissions to check and approve pipeline runs.
  - The pipeline will get the permission to use a service connection in the DevOps project.
  - The given DevOps team or the projects default team will get admin role on the used environment. 

## Prerequisites
  - Personal Access Token for the DevOps Organization
  - A pipeline and environment

## Known Issues
This module used data - http to set some of the permissions. These data - http 'resources' get executed during a terraform plan. If multiple plans/apllies are used, it can happen that errors are thrown, because the permissions already exist. If it is necessary to use multiple plans/applies, you should import the already created resources.
<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >=0.4.0 |
| <a name="requirement_http-full"></a> [http-full](#requirement\_http-full) | 1.3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_definition_id"></a> [build\_definition\_id](#input\_build\_definition\_id) | The ID ob the build definition (pipeline). | `string` | n/a | yes |
| <a name="input_devops_environment"></a> [devops\_environment](#input\_devops\_environment) | The DevOps environment that will be used for the pipeline. | <pre>object({<br>    name = string<br>    id = string <br>  })</pre> | n/a | yes |
| <a name="input_devops_project_name"></a> [devops\_project\_name](#input\_devops\_project\_name) | Name of the DevOps Project where the pipeline is. | `string` | n/a | yes |
| <a name="input_devops_service_url"></a> [devops\_service\_url](#input\_devops\_service\_url) | The URL to the DevOps organization. 'https://dev.azure.com/ORGANIZATION' | `string` | n/a | yes |
| <a name="input_personal_access_token"></a> [personal\_access\_token](#input\_personal\_access\_token) | [Personal access token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat) used for authentication to the Azure DevOps organization. You require the following scopes: `Code`=`Full`, `Environment`=`Read & manage`, `Identity`=`Read & manage`, `Pipeline Resources`=`Use and manage`, `Project and Team`=`Read, write, & manage`, `Security`=`Manage`, `Service Connections`=`Read, query, & manage`,`Variable Groups`=`Read, create, & manage` | `string` | n/a | yes |
| <a name="input_service_connection_id"></a> [service\_connection\_id](#input\_service\_connection\_id) | The ID of the service connection that will be authorized to be used by the pipeline. | `string` | n/a | yes |
| <a name="input_devops_team_name"></a> [devops\_team\_name](#input\_devops\_team\_name) | The DevOps team that gets permissions to use the environment and approve pipelines. If no team is given, the default team from the DevOps project is used. | `string` | `null` | no |
## Outputs

No outputs.

## Resource types

| Type | Used |
|------|-------|
| [azuredevops_pipeline_authorization](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/pipeline_authorization) | 1 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### main.tf

| Name | Type |
|------|------|
| [azuredevops_pipeline_authorization.service_connection_permission](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/pipeline_authorization) | resource |
| [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |
| [azuredevops_team.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/team) | data source |
| [http-full_http.approval_and_check](https://registry.terraform.io/providers/salrashid123/http-full/1.3.1/docs/data-sources/http) | data source |
| [http-full_http.environment_user_permission_alz](https://registry.terraform.io/providers/salrashid123/http-full/1.3.1/docs/data-sources/http) | data source |
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).