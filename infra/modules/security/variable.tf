variable "vpc_id" {
  description = "The VPC ID to create the security groups in"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}