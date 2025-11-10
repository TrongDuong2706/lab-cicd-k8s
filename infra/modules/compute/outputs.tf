output "private_node_id" {
  description = "ID của EC2 private node (K8s host)"
  value       = aws_instance.private_node.id
}

output "bastion_id" {
  description = "ID của bastion instance"
  value       = aws_instance.bastion.id
}

output "jenkins_node_id" {
  description = "The ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_node.id
}
