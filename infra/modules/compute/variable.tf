variable "ami_id" {
  description = "AMI ID cho các EC2 instance."
  type        = string
}

variable "key_name" {
  description = "Tên của SSH key pair."
  type        = string
}

variable "private_subnet_id" {
  description = "ID của private subnet cho các node private."
  type        = string
}

variable "public_subnet_id" {
  description = "ID của public subnet cho bastion host."
  type        = string
}

variable "private_sg_id" {
  description = "ID của Security Group cho các node private."
  type        = string
}

variable "public_sg_id" {
  description = "ID của Security Group cho các node public."
  type        = string
}

variable "k8s_node_instance_type" {
  description = "Loại instance cho Kubernetes node."
  type        = string
}

variable "bastion_instance_type" {
  description = "Loại instance cho Bastion host."
  type        = string
}

variable "jenkins_instance_type" {
  description = "Loại instance cho Jenkins."
  type        = string
}

variable "jenkins_iam_instance_profile_name" {
  description = "Tên của IAM Instance Profile để gắn vào máy chủ Jenkins."
  type        = string
}

variable "tags" {
  description = "Map của các tag để áp dụng cho tài nguyên."
  type        = map(string)
}