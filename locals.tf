locals {
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Basic ${base64encode(":${var.personal_access_token}")}"
  }
}