resource "random_string" "identifier" {
  length  = var.length
  special = var.special
  keepers = {
    prefix = var.prefix
  }
}
