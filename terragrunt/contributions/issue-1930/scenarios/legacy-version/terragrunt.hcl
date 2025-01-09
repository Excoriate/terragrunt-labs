terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/ssm-parameter/aws?version=1.1.2"
}

inputs = {
  prefix = "ssm-legacy-version"
  name   = "/example/parameter"
  value  = "example-value"
}

generate "version" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF
}
