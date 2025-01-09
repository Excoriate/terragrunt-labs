# Issue #1930: Support Version Constraint Syntax for modules loaded from a Terraform registry

## Metadata
- **Organization**: gruntwork-io
- **Repository**: terragrunt
- **Author**: chilicat
- **State**: open
- **Created At**: 2021-11-24T17:10:59Z
- **Updated At**: 2024-09-24T13:47:25Z
- **URL**: https://github.com/gruntwork-io/terragrunt/issues/1930

## Conversations

### Original Issue Description

**Author**: chilicat
**Created At**: 2021-11-24T17:10:59Z

Support Version Constraint Syntax for modules loaded from a Terraform registry:
- https://www.terraform.io/docs/language/expressions/version-constraints.html#version-constraint-syntax


At the moment it is not possible to use the version constrains to load a module from the terraform registry
The current configuration looks like:

```
terraform {
  source = "tfr://myregistry.io/mymodule/azurerm?version=0.0.1"
```
However I would like to be able to use any build version, in Terraform you would configure it like:

```
module "mymodule" {
  source = "myregistry.io/mymodule/azurerm"
  version = "~> 0.0.1"
}
```
The configuration above would automatically use 0.0.2/3/4 if available.


Version:
```
Terraform v1.0.10
Terragrunt version v0.35.12

```

Other resources:
- https://www.terraform.io/docs/internals/module-registry-protocol.html


### Comment #1

**Author**: Chris-Softrams
**Created At**: 2022-06-21T20:00:17Z

Any progress? From https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/ it says:

```
source (attribute): Specifies where to find Terraform configuration files. This parameter supports the exact same syntax as the [module source](https://www.terraform.io/docs/modules/sources.html) parameter for Terraform module
```

### Comment #2

**Author**: yhakbar
**Created At**: 2024-09-24T13:47:20Z

This is a sensible ask, and AFAIK, the only reason it hasn't been implemented is that we haven't prioritized it.

Most folks are able to do just fine with explicit version pins.

That being said, I would happily review a PR to add this capability. If we find bandwidth to address this on the maintainer team, we will also look to address this ourselves.



## Attached Files

No files attached to this issue.


