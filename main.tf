data "azuredevops_project" "this" {
  name = var.devops_project_name
}

data "azuredevops_team" "this" {
  project_id = data.azuredevops_project.this.id
  name       = coalesce(var.devops_team_name, "${data.azuredevops_project.this.name} Team")
}

data "http" "approval_and_check" {
  provider = http-full
  method   = "POST"
  url      = "${var.devops_service_url}/${data.azuredevops_project.this.id}/_apis/pipelines/checks/configurations?api-version=7.0-preview.1"

  request_headers = local.request_headers

  request_body = jsonencode(
    {
      type = {
        id   = "8c6f20a7-a545-4486-9777-f762fafe0d4d"
        name = "Approval"
      }
      settings = {
        approvers = [
          {
            displayName = data.azuredevops_team.this.name,
            id          = data.azuredevops_team.this.id
          }
        ]
        executionOrder            = "anyOrder"
        instructions              = ""
        blockedApprovers          = []
        minRequiredApprovers      = 1
        requesterCannotBeApprover = false
      }
      resource = {
        type = "environment"
        id   = var.devops_environment.id
        name = var.devops_environment.name
      }
      timeout = 43200
    }
  )
}

resource "azuredevops_pipeline_authorization" "service_connection_permission" {
  type        = "queue"
  project_id  = data.azuredevops_project.this.id
  pipeline_id = var.build_definition_id
  resource_id = var.service_connection_id
}

data "http" "environment_user_permission_alz" {
  provider = http-full
  method   = "PUT"
  url      = "${var.devops_service_url}/_apis/securityroles/scopes/distributedtask.environmentreferencerole/roleassignments/resources/${data.azuredevops_project.this.id}_${var.devops_environment.id}?api-version=7.0-preview.1"

  request_headers = local.request_headers
  request_body = jsonencode(
    [
      {
        userId   = data.azuredevops_team.this.id
        roleName = "Administrator"
      }
    ]
  )
}
