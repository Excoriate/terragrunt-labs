locals {
  # Fetch project details from the gcp-setup module outputs
  project_id          = get_env("GCP_PROJECT_ID", "")
  bucket_name         = get_env("SCENARIO_BUCKET_NAME", "")
  bucket_location     = "us-central1"
}

remote_state {
  backend = "gcs"
  config = {
    bucket   = local.bucket_name
    prefix   = "issue-3730/${path_relative_to_include()}"
    project  = local.project_id
    location = local.bucket_location
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  source = "terraform/module-scenario"
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}
EOF
}

inputs = {
  prefix = "issue-3730"
}
