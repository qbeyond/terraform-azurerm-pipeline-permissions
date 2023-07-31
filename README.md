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
provider "azurerm" {
  features {

  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

No inputs.
## Outputs

No outputs.
## Resource types

No resources.


## Modules

No modules.
## Resources by Files

No resources.

<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).