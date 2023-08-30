variable "service_account_id" {
  type = string
}

variable "name_prefix" {
  type     = string
  default  = null
  nullable = true
}

variable "rotation_days" {
  type    = number
  default = 7
}
