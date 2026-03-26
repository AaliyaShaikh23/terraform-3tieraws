variable "project_name" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type    = string
  default = null
}

variable "user_data" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
