# 🔬 Terragrunt Issue Reproduction Template

## Overview

This template provides a standardized, reproducible environment for documenting and reproducing Terragrunt issues. It offers a flexible, containerized setup that allows you to quickly set up an issue-specific workspace.

## 🚀 Quick Start Guide

### 1. Create a New Issue Scenario

1. Copy this template directory to a new `issue-XXXX` folder in `terragrunt/contributions/`

   ```bash
   cp -R templates/V1_NEW_GH_ISSUE_CONTRIBUTION terragrunt/contributions/issue-XXXX
   ```

2. Update `.env` with issue-specific details:
   ```bash
   # .env
   GITHUB_ISSUE_NUMBER=XXXX  # Replace with actual GitHub issue number
   TERRAFORM_VERSION=1.10.2  # Specify the Terraform version used
   TERRAGRUNT_VERSION=v0.71.1  # Specify the Terragrunt version used
   OPENTOFU_VERSION=1.8.0   # Specify OpenTofu version if applicable
   BINARY_ARCH=arm64        # Set architecture (default: arm64)
   ```

### 2. Pull GitHub Issue Details

Automatically download issue details:

```bash
# Pulls issue details from GitHub
make pull-issue

# Or specify a different issue number
make pull-issue issue=5678
```

### 3. Configure Reproduction Environment

#### Dockerfile Customization

- Modify build arguments in `Dockerfile` if specific tool versions or dependencies are needed
- Supports both `mount` and `copy` workspace modes

#### Terragrunt Configuration

Edit `terragrunt.hcl`:

```hcl
locals {
  # Add any local variables specific to the issue
}

terraform {
  source = "terraform/my-module"  # Point to your test module
}

inputs = {
  # Add specific input variables for reproduction
  prefix = "issue-XXXX-repro"
}
```

#### Terraform Module

Create your test module in `terraform/my-module/`:

```
terraform/
└── my-module/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

### 4. Interactive Development

Start an interactive shell:

```bash
# Mount mode (recommended for active development)
make shell

# Copy mode (for consistent, immutable environment)
make shellcp
```

### 5. CLI Wrappers

Run CLI tools within the containerized environment:

```bash
# Terragrunt CLI
make tgcli ARGS="plan"

# OpenTofu CLI
make tofucli ARGS="init"

# Terraform CLI
make tfcli ARGS="validate"
```

## 🛠 Workflow Tips

- Always specify tool versions in `.env`
- Use `mount` mode for active development
- Use `copy` mode for consistent, reproducible scenarios
- Document any specific reproduction steps, troubleshooting, or other relevant information in `TROUBLESHOOTING.MD`

## 🔍 Debugging

- Use `make shell` to interactively debug
- Leverage CLI wrappers for consistent tool execution
- Check container logs and output for issue details
