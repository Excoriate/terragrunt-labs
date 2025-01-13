variable "length" {
  description = "Length of the random string"
  type        = number
  default     = 16
}

variable "special" {
  description = "Include special characters in random string"
  type        = bool
  default     = false
}

variable "prefix" {
  description = "Prefix for generated resources"
  type        = string
  default     = "tg-example"
}
