# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  region  = "us-east-1"
  profile = "sandbox"
  default_tags {
    tags = {
      Environment = test
      Owner = example
      }
  }
}
