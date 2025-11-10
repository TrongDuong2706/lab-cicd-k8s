output "jenkins_ecr_instance_profile_name" {
  description = "The name of the IAM instance profile for Jenkins EC2"
  value       = aws_iam_instance_profile.jenkins_profile.name
}