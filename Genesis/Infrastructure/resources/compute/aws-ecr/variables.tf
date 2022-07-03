variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "genesis_repository_name" {
  type        = string
  description = "(Required) Name of the repository."
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
}
