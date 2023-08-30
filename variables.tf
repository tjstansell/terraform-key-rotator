variable "rotation_days" {
  type        = number
  default     = 7
  description = "How many days to wait before switching keys."
  validation {
    condition     = var.rotation_days > 0
    error_message = "Number of days must be > 0."
  }
}
