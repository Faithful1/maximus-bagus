variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to enable ami with instance"
}

variable "ami" {
  type        = string
  description = "AMI to use for the instance. Setting this will ignore `ami_filter` and `ami_owners`."
  default     = "ami-00826bd51e68b1487"
}

variable "ami_filter" {
  description = "List of maps used to create the AMI filter for the action runner AMI."
  type        = map(list(string))

  default = {
    name                = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    virtualization-type = ["hvm"]
  }
}

variable "ami_owners" {
  description = "The list of owners used to select the AMI of action runner instances."
  type        = list(string)
  default     = ["099720109477"]
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "instance type"
}

variable "enable_monitoring" {
  type        = bool
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = true
}

variable "subnets" {
  type        = list(string)
  description = "AWS subnet IDs"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Key name"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of Security Group IDs to associate with the host."
  default     = []
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = true
  description = "Whether to encrypt the root block device"
}

variable "root_block_device_volume_size" {
  type        = number
  default     = 8
  description = "The volume size (in GiB) to provision for the root block device. It cannot be smaller than the AMI it refers to."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Whether to associate a public IP to the instance."
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
  default     = true
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`)."
}
