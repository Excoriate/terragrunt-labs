variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "bucket_location" {
  description = "The location for the storage bucket"
  type        = string
  default     = "us-central1"
}

variable "bucket_labels" {
  description = "Additional labels for the storage bucket"
  type        = map(string)
  default     = {}
}
