# 🔍 GitHub Issue Puller

## Overview

A lightweight CLI tool to fetch and convert GitHub issues into markdown, designed for seamless issue documentation and tracking.

## 🚀 Features

- Fetch comprehensive issue details
- Convert issues to markdown
- Download attached files
- Configurable organization and repository
- Supports authenticated and unauthenticated requests

## 📦 Prerequisites

- Go 1.20+
- GitHub Personal Access Token (optional)

## 🛠 Installation

```bash
# Clone the repository
git clone https://github.com/Excoriate/terragrunt-labs.git

# Navigate to the tool directory
cd terragrunt-labs/tools/gh-issue-puller

# Build the tool
go build
```

## 🖥️ Usage

### Basic Usage

```bash
# Pull an issue from the default repository (gruntwork-io/terragrunt)
./gh-issue-puller pull --issue 1234
```

### Advanced Options

```bash
# Specify organization and repository
./gh-issue-puller pull \
    --org my-org \
    --repo my-repo \
    --issue 1234 \
    --output /path/to/output
```

### Environment Variables

- `GITHUB_TOKEN`: Set for authenticated requests
  ```bash
  export GITHUB_TOKEN=your_github_personal_access_token
  ```

## 🔐 Authentication

- Unauthenticated: Limited to 60 requests/hour
- Authenticated: Up to 5000 requests/hour

## 📋 Output

The tool generates:

- A markdown file with issue details
- An `attached-files/` directory with issue attachments

## 🧰 Configuration

| Flag       | Description             | Default Value     |
| ---------- | ----------------------- | ----------------- |
| `--org`    | GitHub organization     | `gruntwork-io`    |
| `--repo`   | GitHub repository       | `terragrunt`      |
| `--issue`  | Issue number (required) | None              |
| `--output` | Output path             | Current directory |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

[MIT License](LICENSE)

**Maintained with ❤️ by Alex T.**
