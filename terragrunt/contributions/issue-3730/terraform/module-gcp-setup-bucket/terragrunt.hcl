locals {
  project_id = get_env("GCP_PROJECT_ID", "")
}

terraform {
  source = "${path_relative_from_include()}"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "google" {
      project     = "${local.project_id}"
      credentials = file("${get_env("GOOGLE_APPLICATION_CREDENTIALS", "")}")
    }
  EOF
}

inputs = {
  project_id = local.project_id
}
