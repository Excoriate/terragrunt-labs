# Terragrunt GCS Remote State Configuration Test

## Overview

This repository demonstrates a Terragrunt configuration for creating a Google Cloud Storage (GCS) bucket for remote state management. The setup is designed to be easily reproducible and configurable.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.6.6+)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) (v0.54.12+)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Service Account with Storage Admin permissions

## Setup Instructions

### 1. Create GCP Service Account

1. Open Google Cloud Console
2. Navigate to "IAM & Admin" > "Service Accounts"
3. Create a new service account with the following roles:

   - Storage Admin
   - Service Usage Admin

4. Generate a JSON key for the service account
5. Save the key file as `sa.json` in the project root

### 2. Configure Environment Variables

Create a `.env` file in the project root with the following contents:

```bash
# GCP Configuration
GCP_PROJECT_ID=your-gcp-project-id
GOOGLE_APPLICATION_CREDENTIALS=sa.json

# Optional: Customize bucket configuration
# BUCKET_LOCATION=us-central1  # Uncomment and modify if needed
```

Replace `your-gcp-project-id` with your actual Google Cloud project ID.

### 3. Initialize and Run Terragrunt

```bash
# Initialize Terragrunt
terragrunt init

# Plan the infrastructure
terragrunt plan

# Apply the configuration
terragrunt apply
```

## Configuration Details

### Terraform Files

- `main.tf`: Defines GCS bucket and project service resources
- `variables.tf`: Declares input variables for project and bucket configuration
- `outputs.tf`: Provides output values for the created bucket
- `terragrunt.hcl`: Manages Terragrunt-specific configurations

### Customization Options

You can customize the bucket configuration by modifying the following variables in `variables.tf`:

- `bucket_location`: Set the GCS bucket location (default: `us-central1`)
- `bucket_labels`: Add custom labels to the bucket

### Example Custom Labels

```hcl
# In your Terragrunt command or tfvars file
bucket_labels = {
  environment = "development"
  project     = "terragrunt-test"
}
```

## Troubleshooting

- Ensure the service account JSON key is valid and has the correct permissions
- Verify the `GCP_PROJECT_ID` matches an existing Google Cloud project
- Check that the Google Cloud Storage API is enabled in your project

## Security Considerations

- Never commit the `sa.json` file to version control
- Rotate service account keys periodically
- Use the principle of least privilege when creating service accounts

## License

This project is open-source. Please refer to the LICENSE file for details.
