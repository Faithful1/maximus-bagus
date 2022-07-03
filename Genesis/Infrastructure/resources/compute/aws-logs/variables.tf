variable "genesis_app_log_group_name" {
  default = ""
}

variable "genesis_app_log_retention_in_days" {
  type    = number
  default = 3
}

variable "genesis_app_log_stream_name" {
  default = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}
