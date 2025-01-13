locals {
  bucket_name = "issue-3730"
}

resource "google_project_service" "storage_service" {
  project = var.project_id
  service = "storage.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_storage_bucket" "terragrunt_state" {
  name = format("%s-%s", var.project_id, local.bucket_name)
  project = var.project_id

  # Use default or provided location
  location = coalesce(var.bucket_location, "us-central1")

  # Allow deletion even if not empty
  force_destroy = true

  # Recommended security settings
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"

  # Optional versioning for state files
  versioning {
    enabled = true
  }

  # Merge default and user-provided labels
  labels = merge(
    {
      environment = "test"
      purpose     = "terragrunt-state"
      managed_by  = "terragrunt"
    },
    var.bucket_labels
  )

  # Ensure storage service is enabled before creating bucket
  depends_on = [google_project_service.storage_service]

  # Lifecycle to prevent accidental deletion
  lifecycle {
    prevent_destroy = false
  }
}
