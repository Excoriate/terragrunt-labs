# Terragrunt Test Scenarios

The files in these directories are generated using the `justfile` file. Run:

## Creating a new test issue contribution

```sh
just new-issue issue=1234
```

## Creating a new test scenario

```sh
just new-scenario scenario=testing-edge-case
```

---

## 📂 Directory Structure

### 🚀 `contributions/`

This directory contains actively developed and new test cases for Terragrunt.

- Focuses on emerging issues and potential improvements.
- Potential upstream contributions to the Terragrunt project.

### 🗄️ `archive/`

A collection of historical test scenarios curated by [Denis256](https://github.com/denis256), a core Terragrunt maintainer.

- Preserved test cases from previous investigations
- Valuable reference for understanding past Terragrunt behaviors
- Helps in tracking the evolution of Terragrunt configurations

### 📂 `scenarios/`

A collection of ongoing test scenarios.

- Focuses on emerging issues and potential improvements.
- Any test scenario, POC, or experiment.
