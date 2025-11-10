variable "vpc_id" {
  description = "ID của VPC nơi triển khai ALB."
  type        = string
}

variable "public_subnets" {
  description = "Danh sách ID của các public subnets để gắn ALB."
  type        = list(string)
}

variable "public_sg_id" {
  description = "ID của Security Group cho ALB."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN của chứng chỉ ACM cho listener HTTPS."
  type        = string
}

variable "k8s_node_id" {
  description = "ID của EC2 instance chạy Kubernetes node."
  type        = string
}

variable "jenkins_node_id" {
  description = "ID của EC2 instance chạy Jenkins."
  type        = string
}

variable "full_jenkins_domain_name" {
  description = "Tên miền đầy đủ của Jenkins (ví dụ: jenkins.example.com)."
  type        = string
}

variable "alb_name" {
  description = "Tên cho tài nguyên ALB."
  type        = string
}

variable "k8s_target_group_name" {
  description = "Tên cho Target Group của Kubernetes."
  type        = string
}

variable "jenkins_target_group_name" {
  description = "Tên cho Target Group của Jenkins."
  type        = string
}

variable "k8s_target_port" {
  description = "Cổng mục tiêu cho traffic đến Kubernetes node."
  type        = number
}

variable "jenkins_target_port" {
  description = "Cổng mục tiêu cho traffic đến Jenkins."
  type        = number
}

variable "jenkins_listener_rule_priority" {
  description = "Độ ưu tiên cho rule của Jenkins listener."
  type        = number
}

variable "tags" {
  description = "Map của các tag để áp dụng cho tài nguyên."
  type        = map(string)
}