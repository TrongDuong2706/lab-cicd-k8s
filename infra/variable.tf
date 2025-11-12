# =======================================
# Biến cấu hình chung
# =======================================
variable "region" {
  description = "Khu vực AWS để triển khai tài nguyên."
  type        = string
}

variable "project_tags" {
  description = "Các tag chung sẽ được áp dụng cho tất cả tài nguyên."
  type        = map(string)
}

# =======================================
# Biến cấu hình Mạng
# =======================================
variable "vpc_cidr" {
  description = "Dải CIDR cho VPC."
  type        = string
}

variable "public_subnets" {
  description = "Danh sách các dải CIDR cho public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "Danh sách các dải CIDR cho private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Danh sách các Availability Zone để triển khai subnets."
  type        = list(string)
}

# =======================================
# Biến cấu hình Tên miền
# =======================================
variable "domain_name" {
  description = "Tên miền chính (ví dụ: example.com)."
  type        = string
}

variable "jenkins_subdomain" {
  description = "Tên miền phụ cho Jenkins (ví dụ: jenkins)."
  type        = string
}

# =======================================
# Biến cấu hình Máy chủ
# =======================================
variable "key_name" {
  description = "Tên của EC2 Key Pair đã tồn tại trên AWS."
  type        = string
}

variable "ami_id" {
  description = "AMI ID cho các máy chủ EC2."
  type        = string
}

variable "k8s_node_instance_type" {
  description = "Loại instance cho máy chủ Kubernetes."
  type        = string
}

variable "bastion_instance_type" {
  description = "Loại instance cho máy chủ Bastion Host."
  type        = string
}

variable "jenkins_instance_type" {
  description = "Loại instance cho máy chủ Jenkins."
  type        = string
}

# =======================================
# Biến cấu hình ALB
# =======================================
variable "alb_name" {
  description = "Tên của Application Load Balancer."
  type        = string
}

variable "k8s_target_group_name" {
  description = "Tên của Target Group cho Kubernetes."
  type        = string
}

variable "jenkins_target_group_name" {
  description = "Tên của Target Group cho Jenkins."
  type        = string
}

variable "k8s_target_port" {
  description = "NodePort của Ingress Controller trên node Kubernetes."
  type        = number
}

variable "jenkins_target_port" {
  description = "Cổng của ứng dụng Jenkins trên máy chủ."
  type        = number
}

variable "jenkins_listener_rule_priority" {
  description = "Độ ưu tiên cho rule của Jenkins trên ALB listener."
  type        = number
}

# =======================================
# Biến cấu hình IAM
# =======================================
variable "jenkins_iam_role_name" {
  description = "Tên của IAM Role cho Jenkins."
  type        = string
}

variable "jenkins_iam_instance_profile_name" {
  description = "Tên của IAM Instance Profile cho Jenkins."
  type        = string
}

# ====
# ECR
variable "ecr_repository_names" {
  description = "Danh sách tên các ECR repositories cần tạo."
  type        = list(string)
}

# =======================================
# ARGOCD
variable "argocd_subdomain" {
  description = "Subdomain for ArgoCD"
  type        = string
  default     = "argocd"
}