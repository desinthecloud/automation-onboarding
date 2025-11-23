variable "env_name" {
  description = "Name of the sandbox environment (e.g. project-new-feature)"
  type        = string
}

variable "ttl_hours" {
  description = "Time-to-live for this environment (for reference/cleanup)"
  type        = number
  default     = 24
}

variable "business_owner" {
  description = "Business owner or team for cost tagging"
  type        = string
  default     = "product-team-1"
}
