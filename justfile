# Terragrunt Labs Automation Justfile
# Comprehensive task runner for Terragrunt, Terraform, and Go projects

# Global settings
set dotenv-load
set shell := ["bash", "-uce"]
set export

# Project Paths
TERRAGRUNT_ROOT := "./terragrunt"
TEMPLATES_DIR := "./templates"
CONTRIBUTIONS_DIR := "./terragrunt/contributions"
SCENARIOS_DIR := "./terragrunt/scenarios"
ARCHIVE_DIR := "./terragrunt/archive"
INFRA_DIR := "./infra"

# Environment Configuration
DEFAULT_ENV := "local"
SUPPORTED_ENVS := "local staging production"

# 🚀 Default task: List available recipes
default:
    @just --list

# 🧹 Cleanup Tasks
clean: clean-ds clean-terraform clean-go

# 🗑️ Remove .DS_Store files
clean-ds:
    find . -name '.DS_Store' -type f -delete

# 🧼 Clean Terraform and Terragrunt artifacts
clean-terraform:
    find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
    find . -type f -name "*.tfstate" -delete
    find . -type f -name "*.tfstate.backup" -delete
    find . -type f -name ".terraform.lock.hcl" -delete

# 🧼 Clean Go build artifacts
clean-go:
    go clean -cache
    go clean -testcache
    rm -rf ./bin
    rm -rf ./target


# 🕵️ Terraform formatting
fmt-terraform:
    terraform fmt -recursive

# 🧪 Terragrunt Formatting
fmt-terragrunt:
    terragrunt hclfmt

# 🧪 Go Tests
test-go:
    go test -v ./...

# 🔍 Contribution Workflow
contribute issue='XXXX':
    @echo "Preparing contribution for issue #{{issue}}"
    @mkdir -p $(CONTRIBUTIONS_DIR)/issue-{{issue}}
    @echo "Created contribution directory: $(CONTRIBUTIONS_DIR)/issue-{{issue}}"

# 📋 List Contributions
list-contributions:
    @echo "🔍 Available Contributions:"
    @echo "----------------------------"
    @ls -1 ./terragrunt/contributions | sed 's/^/  /' || echo "  No contributions found."
    @echo "----------------------------"
    @echo "Total Contributions: $(ls -1 ./terragrunt/contributions | wc -l | tr -d ' ')"

# 📋 List Archived Scenarios
list-archives:
    @echo "🗄️  Archived Scenarios:"
    @echo "----------------------------"
    @ls -1 ./terragrunt/archive | sed 's/^/  /' || echo "  No archives found."
    @echo "----------------------------"
    @echo "Total Archives: $(ls -1 ./terragrunt/archive | wc -l | tr -d ' ')"

# 🔍 Find Issue in Contributions or Archives
find-issue issue:
    @echo "🕵️  Searching for Issue #{{issue}}:"
    @echo "----------------------------"
    @echo "🔬 Contributions:"
    @find ./terragrunt/contributions -type d -name "*issue-{{issue}}*" -print0 | xargs -0 -I {} sh -c 'echo "  📁 {}"' || echo "  🚫 No matching contributions found"
    @echo "\n🗄️  Archives:"
    @find ./terragrunt/archive -type d -name "*issue-{{issue}}*" -print0 | xargs -0 -I {} sh -c 'echo "  📁 {}"' || echo "  🚫 No matching archives found"
    @echo "----------------------------"

# 🐳 Open interactive shell in Terragrunt container with mount workspace
docker-shell provider='hashicorp' terraform_version='1.10.2' terragrunt_version='v0.71.1' tofu_version='1.8.0' arch='arm64': (build-docker provider terraform_version terragrunt_version tofu_version arch 'mount')
    @echo "🚀 Opening Terragrunt container shell (mount mode)"
    @docker run -it \
        -v $(PWD):/workspace \
        terragrunt-labs:{{terraform_version}}-{{arch}} \
        /bin/bash

# 🐳 Open interactive shell in Terragrunt container with copy workspace
docker-shellcp provider='hashicorp' terraform_version='1.10.2' terragrunt_version='v0.71.1' tofu_version='1.8.0' arch='arm64': (build-docker provider terraform_version terragrunt_version tofu_version arch 'copy')
    @echo "🚀 Opening Terragrunt container shell (copy mode)"
    @docker run -it \
        -v $(PWD):/host \
        -e WORKSPACE_MODE=copy \
        terragrunt-labs:{{terraform_version}}-{{arch}} \
        /bin/bash

# 🐳 Terragrunt CLI wrapper (mount mode)
tgcli *args:
    @echo "🔍 Running Terragrunt CLI in container (mount mode)"
    @docker run --rm \
        -v $(PWD):/workspace \
        -w /workspace \
        terragrunt-labs:latest \
        sh -c 'terragrunt {{args}} || (echo "❌ Terragrunt command failed" && exit 1)'

# 🐳 Terragrunt CLI wrapper (copy mode)
tgclcp *args:
    @echo "🔍 Running Terragrunt CLI in container (copy mode)"
    @docker run --rm \
        -v $(PWD):/host \
        -w /workspace \
        -e WORKSPACE_MODE=copy \
        terragrunt-labs:latest \
        sh -c 'terragrunt {{args}} || (echo "❌ Terragrunt command failed" && exit 1)'

# 🐳 OpenTofu CLI wrapper (mount mode)
tofucli *args:
    @echo "🔍 Running OpenTofu CLI in container (mount mode)"
    @docker run --rm \
        -v $(PWD):/workspace \
        -w /workspace \
        terragrunt-labs:latest \
        sh -c 'tofu {{args}} || (echo "❌ OpenTofu command failed" && exit 1)'

# 🐳 OpenTofu CLI wrapper (copy mode)
tofuclcp *args:
    @echo "🔍 Running OpenTofu CLI in container (copy mode)"
    @docker run --rm \
        -v $(PWD):/host \
        -w /workspace \
        -e WORKSPACE_MODE=copy \
        terragrunt-labs:latest \
        sh -c 'tofu {{args}} || (echo "❌ OpenTofu command failed" && exit 1)'

# 🐳 Terraform CLI wrapper (mount mode)
tfcli *args:
    @echo "🔍 Running Terraform CLI in container (mount mode)"
    @docker run --rm \
        -v $(PWD):/workspace \
        -w /workspace \
        terragrunt-labs:latest \
        sh -c 'terraform {{args}} || (echo "❌ Terraform command failed" && exit 1)'

# 🔍 Terraform CLI wrapper (copy mode)
tfclcp *args:
    @echo "🔍 Running Terraform CLI in container (copy mode)"
    @docker run --rm \
        -v $(PWD):/host \
        -w /workspace \
        -e WORKSPACE_MODE=copy \
        terragrunt-labs:latest \
        sh -c 'terraform {{args}} || (echo "❌ Terraform command failed" && exit 1)'

# 🔍 GitHub Issue Puller Compile
compile-gh-issue-puller:
    @echo "🔨 Compiling GitHub Issue Puller..."
    @cd tools/gh-issue-puller && go build -o gh-issue-puller main.go
    @echo "✅ Compilation successful"

# Pull and convert GitHub issues to markdown
pull-issue issue='0' org='gruntwork-io' repo='terragrunt' output='.':
    @echo "🕵️  Pulling GitHub Issue #{{issue}}"
    @chmod +x tools/gh-issue-puller/gh-issue-puller
    @tools/gh-issue-puller/gh-issue-puller pull \
        -i {{issue}} \
        -o {{org}} \
        -r {{repo}} \
        -p {{output}} || (echo "❌ Issue pull failed" && exit 1)
    @echo "✅ Issue successfully pulled and saved"

# Clean up compiled binaries
clean-gh-issue-puller:
    @echo "🧹 Cleaning GitHub Issue Puller binary..."
    @rm -f tools/gh-issue-puller/gh-issue-puller
    @echo "✅ Cleanup complete"

# 🐳 Build Terragrunt Docker image
build-docker provider='hashicorp' terraform_version='1.10.2' terragrunt_version='v0.71.1' tofu_version='1.8.0' arch='arm64' workspace_mode='mount':
    @echo "🏗️  Building Terragrunt Docker image"
    @echo "  Provider: {{provider}}"
    @echo "  Terraform Version: {{terraform_version}}"
    @echo "  Terragrunt Version: {{terragrunt_version}}"
    @echo "  OpenTofu Version: {{tofu_version}}"
    @echo "  Architecture: {{arch}}"
    @echo "  Workspace Mode: {{workspace_mode}}"
    @docker build \
        --build-arg TERRAFORM_PROVIDER={{provider}} \
        --build-arg TERRAFORM_VERSION={{terraform_version}} \
        --build-arg TERRAGRUNT_VERSION={{terragrunt_version}} \
        --build-arg OPENTOFU_VERSION={{tofu_version}} \
        --build-arg BINARY_ARCH={{arch}} \
        --build-arg WORKSPACE_MODE={{workspace_mode}} \
        -t terragrunt-labs:{{terraform_version}}-{{arch}} \
        -t terragrunt-labs:latest .

# 🚀 Create a new issue contribution from template
new-issue issue:
    @echo "🚀 Creating new issue contribution for #{{issue}}"
    @mkdir -p "$(PWD)/terragrunt/contributions/issue-{{issue}}"
    @if [ ! -d "$(PWD)/templates/V1_NEW_GH_ISSUE_CONTRIBUTION" ]; then \
        echo "❌ Template directory not found. Please check the path."; \
        exit 1; \
    fi
    @cp -R "$(PWD)/templates/V1_NEW_GH_ISSUE_CONTRIBUTION"/* "$(PWD)/terragrunt/contributions/issue-{{issue}}/"
    @if [ ! -f "$(PWD)/terragrunt/contributions/issue-{{issue}}/.env" ]; then \
        touch "$(PWD)/terragrunt/contributions/issue-{{issue}}/.env"; \
        echo "GITHUB_ISSUE_NUMBER={{issue}}" > "$(PWD)/terragrunt/contributions/issue-{{issue}}/.env"; \
    else \
        sed -i '' 's/GITHUB_ISSUE_NUMBER=.*/GITHUB_ISSUE_NUMBER={{issue}}/' "$(PWD)/terragrunt/contributions/issue-{{issue}}/.env"; \
    fi
    @echo "✅ Issue contribution template created successfully in $(PWD)/terragrunt/contributions/issue-{{issue}}"
    @echo "📜 Listing all generated files:"
    @ls -ltrah "$(PWD)/terragrunt/contributions/issue-{{issue}}"
    @echo "🔍 Next steps:"
    @echo "  1. cd $(PWD)/terragrunt/contributions/issue-{{issue}}"
    @echo "  2. Review and customize the files"
    @echo "  3. Start reproducing the issue"
    @echo "  4. Pull the GitHub issue details, for that, ensure you're running make pull-issue issue={{issue}} or replace the issue number in the environment variable GITHUB_ISSUE_NUMBER in the .env file"

# 🚀 Create a new scenario in the terragrunt/scenarios directory
new-scenario scenario:
    @echo "🚀 Creating new scenario in the terragrunt/scenarios directory"
    @mkdir -p "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}"
    @if [ ! -d "$(PWD)/templates/V1_NEW_GH_ISSUE_CONTRIBUTION" ]; then \
        echo "❌ Template directory not found. Please check the path."; \
        exit 1; \
    fi
    @cp -R "$(PWD)/templates/V1_NEW_GH_ISSUE_CONTRIBUTION"/* "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}/"
    @if [ ! -f "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}/.env" ]; then \
        touch "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}/.env"; \
        echo "SCENARIO_NAME={{scenario}}" > "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}/.env"; \
    else \
        sed -i '' 's/SCENARIO_NAME=.*/SCENARIO_NAME={{scenario}}/' "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}/.env"; \
    fi
    @echo "✅ Scenario created successfully in $(PWD)/terragrunt/scenarios/scenario-{{scenario}}"
    @echo "📜 Listing all generated files:"
    @ls -ltrah "$(PWD)/terragrunt/scenarios/scenario-{{scenario}}"
    @echo "🔍 Next steps:"
    @echo "  1. cd $(PWD)/terragrunt/scenarios/scenario-{{scenario}}"
    @echo "  2. Review and customize the files"
    @echo "  3. Set up your scenario configuration"
