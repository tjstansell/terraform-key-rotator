variable "service_account_id" {
  type = string
}

variable "key_prefix" {
  type        = string
  default     = null
  nullable    = true
  description = "If specified, name the keys $${key_prefix}A and $${key_prefix}B.  Otherwise, use random names."
}

variable "rotation_days" {
  type    = number
  default = 7
}
