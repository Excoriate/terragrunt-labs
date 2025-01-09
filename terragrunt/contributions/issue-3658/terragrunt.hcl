locals {
  # repo_root = "${get_repo_root()}"
}

terraform {
  source = "terraform/my-module"
}

inputs = {
  prefix         = "tg-boilerplate"
}

# generate "providers" {
#   path      = "providers.tf"
#   if_exists = "overwrite"
#   contents  = <<EOF
# terraform {
#   required_providers {
#     random = {
#       source = "hashicorp/random"
#     }
#   }
# }
# EOF
# }
