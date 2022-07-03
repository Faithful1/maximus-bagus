# Labels
variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev'"
}

variable "owner" {
  type        = string
  description = "managed-by e.g. 'terraform'"
}


variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. `app` or `docker`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "log_group_name" {
  default = ""
}

variable "log_stream_name" {
  default = ""
}

variable "retention_in_days" {
  type    = number
  default = 3
}


variable "tasks_log_group_name" {
  default = ""
}

variable "tasks_log_stream_name" {
  default = ""
}

variable "enable_logs" {
  description = "If true, scheduler is deployed"
  type        = bool
  default     = false
}
