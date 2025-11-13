# =======================================
# Cấu hình chung cho toàn bộ Project
# =======================================
region       = "ap-southeast-1"
project_tags = {
  Project   = "Terraform-VPC"
  ManagedBy = "Terraform"
}

# =======================================
# Cấu hình Mạng (Networking)
# =======================================
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

# =======================================
# Cấu hình Tên miền (DNS & ACM)
# =======================================
domain_name        = "trongduong.website"
jenkins_subdomain  = "jenkins"

# =======================================
ecr_policy = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"

# =======================================
# Cấu hình Máy chủ (Compute)
# =======================================
key_name                 = "lab-cicd"
ami_id                   = "ami-0827b3068f1548bf6" 
k8s_node_instance_type   = "t3.medium"
bastion_instance_type    = "t2.micro"
jenkins_instance_type    = "t3.medium"

# =======================================
# Cấu hình ALB & Target Groups
# =======================================
alb_name                      = "main-alb"
k8s_target_group_name         = "tg-k8s-ingress"
jenkins_target_group_name     = "tg-jenkins"
k8s_target_port               = 30080
jenkins_target_port           = 8080
jenkins_listener_rule_priority = 10

# =======================================
# Cấu hình IAM
# =======================================
jenkins_iam_role_name             = "jenkins-ecr-role"
jenkins_iam_instance_profile_name = "jenkins-ecr-instance-profile"


# =======================================
# ECR
ecr_repository_names = ["backend", "frontend"]

