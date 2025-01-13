# Makefile for Terragrunt Issue Reproduction

# Default environment file
ENV_FILE ?= .env

# Load environment variables from .env file (optional)
-include $(ENV_FILE)

# Docker build arguments with support for additional environment variables
DOCKER_BUILD_ARGS = \
	--build-arg TERRAFORM_PROVIDER="$(or $(TERRAFORM_PROVIDER),hashicorp)" \
	--build-arg TERRAFORM_VERSION="$(or $(TERRAFORM_VERSION),1.10.2)" \
	--build-arg TERRAGRUNT_VERSION="$(or $(TERRAGRUNT_VERSION),v0.71.1)" \
	--build-arg OPENTOFU_VERSION="$(or $(OPENTOFU_VERSION),1.8.0)" \
	--build-arg BINARY_ARCH="$(or $(BINARY_ARCH),arm64)"

# Collect only specific environment variables to pass to the container
ALLOWED_VARS := CUSTOM_VAR DEBUG LOG_LEVEL GCP_PROJECT_ID GOOGLE_APPLICATION_CREDENTIALS GCP_BILLING_ACCOUNT_ID

# Additional environment variables to pass to the container
DOCKER_ENV_ARGS = $(foreach var,$(ALLOWED_VARS),-e $(var)="$(value $(var))")

# --------------------------------------------------------------------
#  Build & Shell Targets
# --------------------------------------------------------------------

# Get the directory of the Makefile
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Mount-mode shell:
# 1. Build image with WORKSPACE_MODE=mount
# 2. Run container with local directory mounted at /workspace
.PHONY: shell
shell:
	@echo "Building Docker image (mount mode) ..."
	docker build $(DOCKER_BUILD_ARGS) \
		--build-arg WORKSPACE_MODE=mount \
		--build-arg BINARY_ARCH=arm64 \
		-t terragrunt-issue-repro \
		-f Dockerfile $(MAKEFILE_DIR)
	@echo "Starting interactive shell (mount mode) ..."
	docker run -it --rm \
		-v $(MAKEFILE_DIR):/workspace \
		--entrypoint /bin/sh \
		terragrunt-issue-repro \
		-c 'uname -m && ls /bin && echo "Shell test" && exec /bin/sh'

# Copy-mode shell:
# 1. Build image with WORKSPACE_MODE=copy
# 2. Run container (files are already copied at build time)
.PHONY: shellcp
shellcp:
	@echo "Building Docker image (copy mode) ..."
	docker build $(DOCKER_BUILD_ARGS) \
		--build-arg WORKSPACE_MODE=copy \
		--build-arg BINARY_ARCH=arm64 \
		-t terragrunt-issue-repro-copy \
		-f Dockerfile $(MAKEFILE_DIR)
	@echo "Starting interactive shell (copy mode) ..."
	docker run -it --rm \
		--entrypoint /bin/sh \
		terragrunt-issue-repro-copy \
		-c 'uname -m && ls /bin && echo "Shell test" && exec /bin/sh'

# --------------------------------------------------------------------
#  CLI Wrappers for Terragrunt, OpenTofu, and Terraform
# --------------------------------------------------------------------
# mount-mode -> uses 'terragrunt-issue-repro'
# copy-mode  -> uses 'terragrunt-issue-repro-copy'

.PHONY: tgcli tofucli tfcli tgclcp tofuclcp tfclcp

# Terragrunt CLI wrapper (mount mode)
tgcli:
	@echo "🔍 Running Terragrunt CLI in container (mount mode)"
	docker run --rm \
		-v $(MAKEFILE_DIR):/workspace \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro \
		sh -c 'terragrunt $(ARGS) || (echo "❌ Terragrunt command failed" && exit 1)'

# Terragrunt CLI wrapper (copy mode)
tgclcp:
	@echo "🔍 Running Terragrunt CLI in container (copy mode)"
	docker run --rm \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro-copy \
		sh -c 'terragrunt $(ARGS) || (echo "❌ Terragrunt command failed" && exit 1)'

# OpenTofu CLI wrapper (mount mode)
tofucli:
	@echo "🔍 Running OpenTofu CLI in container (mount mode)"
	docker run --rm \
		-v $(MAKEFILE_DIR):/workspace \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro \
		sh -c 'tofu $(ARGS) || (echo "❌ OpenTofu command failed" && exit 1)'

# OpenTofu CLI wrapper (copy mode)
tofuclcp:
	@echo "🔍 Running OpenTofu CLI in container (copy mode)"
	docker run --rm \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro-copy \
		sh -c 'tofu $(ARGS) || (echo "❌ OpenTofu command failed" && exit 1)'

# Terraform CLI wrapper (mount mode)
tfcli:
	@echo "🔍 Running Terraform CLI in container (mount mode)"
	docker run --rm \
		-v $(MAKEFILE_DIR):/workspace \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro \
		sh -c 'terraform $(ARGS) || (echo "❌ Terraform command failed" && exit 1)'

# Terraform CLI wrapper (copy mode)
tfclcp:
	@echo "🔍 Running Terraform CLI in container (copy mode)"
	docker run --rm \
		-w /workspace \
		$(DOCKER_ENV_ARGS) \
		terragrunt-issue-repro-copy \
		sh -c 'terraform $(ARGS) || (echo "❌ Terraform command failed" && exit 1)'

# --------------------------------------------------------------------
#  GitHub Issue Puller Target
# --------------------------------------------------------------------

# Use GITHUB_ISSUE_NUMBER from .env if not overridden
ISSUE ?= $(or $(GITHUB_ISSUE_NUMBER),)

# Path to the GitHub issue puller tool
GH_ISSUE_PULLER_PATH := ../../../tools/gh-issue-puller

# Target to pull a GitHub issue
.PHONY: pull-issue
pull-issue:
	@if [ -z "$(ISSUE)" ]; then \
		echo "Error: No GitHub issue number provided. Use 'make pull-issue issue=XXXX' or set GITHUB_ISSUE_NUMBER in .env"; \
		exit 1; \
	fi
	@echo "Pulling GitHub issue #$(ISSUE) ..."
	@cd $(GH_ISSUE_PULLER_PATH) && go run main.go pull -i $(ISSUE) -o gruntwork-io -r terragrunt -p $(MAKEFILE_DIR)

# --------------------------------------------------------------------
#  Help
# --------------------------------------------------------------------
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  shell    - Build and start an interactive shell (mount mode)."
	@echo "  shellcp  - Build and start an interactive shell (copy mode)."
	@echo "  tgcli    - Run Terragrunt CLI in container (mount mode)."
	@echo "  tgclcp   - Run Terragrunt CLI in container (copy mode)."
	@echo "  tofucli  - Run OpenTofu CLI in container (mount mode)."
	@echo "  tofuclcp - Run OpenTofu CLI in container (copy mode)."
	@echo "  tfcli    - Run Terraform CLI in container (mount mode)."
	@echo "  tfclcp   - Run Terraform CLI in container (copy mode)."
	@echo "  pull-issue [issue=XXXX] - Pull a GitHub issue by number."
	@echo "  help     - Display this help message."

# Default target
.DEFAULT_GOAL := help

# --------------------------------------------------------------------
#  GCP Setup
# These targets are meant to recreate the GCP environment for the issue. They create:
# - A GCP project
# - A GCS bucket
# --------------------------------------------------------------------
.PHONY: gcp-setup
gcp-setup-plan:
	cd terraform/module-gcp-setup-bucket && \
	GCP_PROJECT_ID=$(GCP_PROJECT_ID) \
	GCP_BILLING_ACCOUNT_ID=$(GCP_BILLING_ACCOUNT_ID) \
	GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS) \
	terragrunt plan

.PHONY: gcp-setup-apply
gcp-setup-apply:
	cd terraform/module-gcp-setup-bucket && \
	GCP_PROJECT_ID=$(GCP_PROJECT_ID) \
	GCP_BILLING_ACCOUNT_ID=$(GCP_BILLING_ACCOUNT_ID) \
	GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS) \
	terragrunt apply -auto-approve

.PHONY: gcp-setup-destroy
gcp-setup-destroy:
	cd terraform/module-gcp-setup-bucket && \
	GCP_PROJECT_ID=$(GCP_PROJECT_ID) \
	GCP_BILLING_ACCOUNT_ID=$(GCP_BILLING_ACCOUNT_ID) \
	GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS) \
	terragrunt destroy -auto-approve

# --------------------------------------------------------------------
#  Scenario
# --------------------------------------------------------------------
.PHONY: scenario-plan
scenario-plan:
	cd terraform/module-scenario && \
	GCP_PROJECT_ID=$(GCP_PROJECT_ID) \
	GCP_BILLING_ACCOUNT_ID=$(GCP_BILLING_ACCOUNT_ID) \
	GOOGLE_APPLICATION_CREDENTIALS=$(GOOGLE_APPLICATION_CREDENTIALS) \
	terragrunt plan --terragrunt-log-level debug
