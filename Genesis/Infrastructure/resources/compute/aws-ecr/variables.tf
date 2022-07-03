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

variable "main_repository_name" {
  type        = string
  default     = ""
  description = "the ecr image repository name"
}

variable "task_repository_name" {
  type        = string
  default     = ""
  description = "the ecr image repository name"
}

variable "cms_repository_name" {
  type        = string
  default     = ""
  description = "the ecr image repository name"
}

variable "is_staging" {
  type        = bool
  default     = false
  description = "allow images to be scanned when pushed to ecr"
}

variable "is_prod" {
  type        = bool
  default     = false
  description = "allow images to be scanned when pushed to ecr"
}

variable "is_cms" {
  type        = bool
  default     = false
  description = "allow images to be scanned when pushed to ecr"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "allow images to be scanned when pushed to ecr"
}