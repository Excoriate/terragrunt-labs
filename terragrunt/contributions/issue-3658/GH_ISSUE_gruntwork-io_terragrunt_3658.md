# Issue #3658: Add option to override default terragrunt boilerplate template for terragrunt catalog

## Metadata
- **Organization**: gruntwork-io
- **Repository**: terragrunt
- **Author**: tgeijg
- **State**: open
- **Created At**: 2024-12-13T19:15:18Z
- **Updated At**: 2024-12-23T02:35:57Z
- **URL**: https://github.com/gruntwork-io/terragrunt/issues/3658

## Conversations

### Original Issue Description

**Author**: tgeijg
**Created At**: 2024-12-13T19:15:18Z

## Describe the enhancement

Currently `terragrunt scaffold` has three ways of consuming a boilerplate template:
1. The built-in default terragrunt template
2. Supplying a custom template as the second argument to the scaffold command
3. Adding a `.boilerplate` folder in the terraform module

When using `terragrunt catalog` option 2 is not available. Additionally, the default terragrunt boilerplate template is not particularly useful. That leaves only option 3. This is not ideal for reasons listed below.

The request would be to add an option to the catalog config that would allow overriding the default template:
```
catalog {
  boilerplate_template = "https://github.com/gruntwork-io/custom-boilerplate-template",
  urls = [
    "https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example",
    "https://github.com/gruntwork-io/terraform-aws-utilities",
    "https://github.com/gruntwork-io/terraform-kubernetes-namespace"
  ]
}
```


## Additional context

The result of the current options for defining a custom boilerplate template in combination with `terragrunt catalog` is that we end up needing to maintain boilerplate templates in all our terraform modules. Since many of these templates are 99.9% identical, it would be much easier for us to maintain a single boilerplate template which can be in its own remote repository. Any updates to that template then automatically apply to all terraform modules, and do not require us to go and update hundreds of terraform modules.

### Comment #1

**Author**: yhakbar
**Created At**: 2024-12-20T15:17:38Z

This seems like a totally sensible request, @tgeijg . I'm not sure when we'd be able to prioritize it, so I'll mark it as requesting community contributions. 

It seems like you have a good number of features you'd like to see in boilerplate/scaffold/catalog. If I haven't asked already, are you interested in becoming a Terragrunt contributor?

### Comment #2

**Author**: grahitoraditya
**Created At**: 2024-12-23T02:35:56Z

saya tertarik dengan masalah ini, ini sangat mendewasakan saya dalam belajar pemrograman



## Attached Files

No files attached to this issue.


