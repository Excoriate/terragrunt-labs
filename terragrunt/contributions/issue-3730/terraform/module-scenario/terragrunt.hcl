locals {
  # Fetch project details from the gcp-setup module outputs
  project_id          = get_env("GCP_PROJECT_ID", "")
  bucket_name = format("%s-%s", get_env("GCP_PROJECT_ID", ""), "issue-3730")
  bucket_location     = "us-central1"
}

remote_state {
  backend = "gcs"
  config = {
    bucket   = local.bucket_name
    prefix   = "issue-3730/${path_relative_to_include()}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
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
