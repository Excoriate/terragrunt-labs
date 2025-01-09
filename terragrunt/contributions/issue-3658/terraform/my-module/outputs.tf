output "random_string" {
  description = "Generated random string"
  value       = random_string.identifier.result
  sensitive   = false
}
