terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/ssm-parameter/aws"
  version = "1.1.2-beta.1"
}

inputs = {
  prefix = "ssm-pre-release-version"
  name   = "/example/parameter"
  value  = "example-value"
}

generate "version" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<-EOF2
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF2
}

