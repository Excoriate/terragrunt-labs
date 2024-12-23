# Terragrunt Labs 🏗️

## Overview 🌐

Terragrunt Labs is a systematic infrastructure testing and validation platform designed to enhance the reliability and functionality of Terragrunt. Our mission is to provide precise, reproducible test environments and streamline the contribution workflow for infrastructure configurations.

## 🎯 Key Objectives

- **Issue Reproduction**: Create precise, reproducible test scenarios
- **Contribution Workflow**: Standardize upstream contribution processes
- **Multi-Tool Compatibility**: Seamless integration with Terraform, Terragrunt, and OpenTofu

## 🛠 Supported Technologies

| Technology | Purpose                           |
| ---------- | --------------------------------- |
| Terragrunt | Infrastructure orchestration      |
| Terraform  | Infrastructure as Code (IaC)      |
| OpenTofu   | Open-source Terraform alternative |

## 🚀 Quick Start Guide

### Prerequisites

- 🐳 Docker
- 🏃 [just](https://github.com/casey/just) task runner

### Installation & Setup

Clone the repository and navigate to the project directory.

```bash
# Clone the repository
git clone https://github.com/Excoriate/terragrunt-labs.git
cd terragrunt-labs
```

List all available commands

```bash
just
```

## 📂 Repository Structure

| Directory                   | Purpose                                   |
| --------------------------- | ----------------------------------------- |
| `terragrunt/contributions/` | Active test cases and issue reproductions |
| `terragrunt/archive/`       | Historical test scenarios                 |
| `terragrunt/scenarios/`     | Experimental and ongoing test scenarios   |

## 🧰 Development Workflow

### Available Tools

- `justfile`: Task automation and CLI workflows
- `Makefile`: Template management for GitHub issue contributions
- `tools/gh-issue-puller`: GitHub issue details puller (see [README](tools/gh-issue-puller/README.md))

#### Pulling GitHub Issue Details

```bash
# Pull GitHub issue details
just pull-issue issue=1234

# Or, in the issue directory
make pull-issue issue=1234
```

## 📋 Workflow Scenarios

### Creating a GitHub Issue Contribution

#### Manual Method

1. Copy template to new issue directory

```bash
cp -R "templates/V1_NEW_GH_ISSUE_CONTRIBUTION" "terragrunt/contributions/issue-1234"
```

2. Navigate to issue directory

```bash
cd terragrunt/contributions/issue-1234
```

3. Pull GitHub issue details

```bash
make pull-issue issue=1234
```

4. Optional: Adjust configurations in `.env` file

#### Automated Method

1. Create new issue contribution

```bash
just new-issue issue=1234
```

2. Pull issue details

```bash
cd terragrunt/contributions/issue-1234
make pull-issue issue=1234
```

### Creating a New Test Scenario

```bash
just new-scenario scenario=testing-edge-case
```

## 📄 License

[MIT License](LICENSE)

**Maintained with ❤️ by Alex T.**
