variable "role_name" {
  description = "Tên cho IAM Role."
  type        = string
}

variable "instance_profile_name" {
  description = "Tên cho IAM Instance Profile."
  type        = string
}

variable "ecr_policy" {
  description = "ecr policy"
  type        = string
}

variable "tags" {
  description = "Map của các tag để áp dụng cho tài nguyên."
  type        = map(string)
}