# Terragrunt Issue #1930: Version Constraint Support

## Scenarios

This directory contains different scenarios demonstrating the lack of version constraint support in Terragrunt for modules loaded from a Terraform registry.

### Scenarios

1. `exact-version/`: Uses an exact version constraint

   - `source = "tfr://terraform-aws-modules/ssm-parameter/aws?version=1.0.0"`

2. `range-version/`: Uses a version range constraint

   - `source = "tfr://terraform-aws-modules/ssm-parameter/aws?version=~> 1.0.0"`

3. `pre-release-version/`: Uses a pre-release version

   - `source = "tfr://terraform-aws-modules/ssm-parameter/aws?version=1.0.0-beta.1"`

4. `exclude-version/`: Attempts to exclude a specific version

   - `source = "tfr://terraform-aws-modules/ssm-parameter/aws?version=!= 1.0.0"`

5. `legacy-version/`: Current approach with explicit version pin
   - `source = "tfr://terraform-aws-modules/ssm-parameter/aws?version=1.0.0"`

## How to run

Start a shell in the container:

```bash
make shell
```

Run the scenario:

```bash
# replace `legacy-version` with the scenario you want to run
terragrunt init \
  --terragrunt-working-dir scenarios/legacy-version/ \
  --terragrunt-tfpath $(which terraform)

# replace `legacy-version` with the scenario you want to run
terragrunt plan \
  --terragrunt-working-dir scenarios/legacy-version/ \
  --terragrunt-tfpath $(which terraform)
```

> NOTE: The `terragrunt-tfpath` is required to ensure Terragrunt uses the correct Terraform binary. Since opentofu and terraform are both installed, Terragrunt will use the correct one based on the `terragrunt-tfpath` argument. By default, Terragrunt will use the `open tofu` binary.
