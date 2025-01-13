# GCP Project Setup for Terragrunt Issue 3730

## Overview

This Terraform module creates a GCP project with the following key features:

- Dynamically generates a unique project ID
- Enables essential GCP services
- Creates a versioned storage bucket for state management

## Prerequisites

### 1. GCP Authentication

- Ensure you're authenticated with Google Cloud
- Run `gcloud auth application-default login` before executing Terragrunt commands

### 2. Billing Account Configuration

- A billing account is **required** to create and manage GCP projects
- Set the billing account ID in your `.env` file:
  ```
  GCP_BILLING_ACCOUNT_ID=YOUR_BILLING_ACCOUNT_ID
  ```

### 3. Required Environment Variables

- `GCP_BILLING_ACCOUNT_ID`: Your GCP billing account ID
- Recommended optional variables:
  ```
  # Customize project and bucket configuration
  BUCKET_LOCATION=us-central1  # Default storage bucket location
  PROJECT_LABELS='{"team":"devops","environment":"test"}'
  ```

## Configuration Options

### Project Configuration

- Automatically generates a unique project ID
- Sets default labels:
  - `environment`: test
  - `issue`: 3730
  - `managed_by`: terragrunt

### Services Enabled

- `storage.googleapis.com`: Google Cloud Storage
- `cloudresourcemanager.googleapis.com`: Resource management

### Storage Bucket Configuration

- Location: Configurable (default: us-central1)
- Versioning: Enabled
- Access Control: Uniform bucket-level access
- Deletion Protection: Configurable via Terraform lifecycle block

## Execution

### Using Makefile

```bash
# Run Terragrunt plan
make gcp-setup-plan

# Apply changes
make gcp-setup-apply
```

### Manual Execution

```bash
# Navigate to the directory
cd terraform/gcp-setup

# Set billing account (optional if in .env)
export GCP_BILLING_ACCOUNT_ID=YOUR_BILLING_ACCOUNT_ID

# Run Terragrunt commands
terragrunt plan
terragrunt apply
```

## Notes

- This setup is specifically for Terragrunt Issue 3730 testing
- Customize variables in `variables.tf` as needed
