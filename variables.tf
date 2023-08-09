variable "build_definition_id" {
  type = string
  description = "The ID ob the build definition (pipeline)." 
}

variable "devops_environment" {
  type = object({
    name = string
    id = string 
  })
  description = "The DevOps environment that will be used for the pipeline."
}

variable "devops_team_name" {
  type =  string
  default = null
  description = "The DevOps team that gets permissions to use the environment and approve pipelines. If no team is given, the default team from the DevOps project is used."
}

variable "devops_project_name" {
  type        = string
  description = "Name of the DevOps Project where the pipeline is."
}

variable "devops_service_url" {
  type        = string
  description = "The URL to the DevOps organization. 'https://dev.azure.com/ORGANIZATION'"
}

variable "personal_access_token" {
  type        = string
  description = "[Personal access token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-a-pat) used for authentication to the Azure DevOps organization. You require the following scopes: `Code`=`Full`, `Environment`=`Read & manage`, `Identity`=`Read & manage`, `Pipeline Resources`=`Use and manage`, `Project and Team`=`Read, write, & manage`, `Security`=`Manage`, `Service Connections`=`Read, query, & manage`,`Variable Groups`=`Read, create, & manage`"
  sensitive = true
}

variable "service_connection_id" {
  type = string
  description = "The ID of the service connection that will be authorized to be used by the pipeline."
}


