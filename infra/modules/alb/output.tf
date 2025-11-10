output "alb_dns_name" {
  description = "Tên DNS của ALB."
  value       = aws_lb.main_alb.dns_name
}

output "alb_zone_id" {
  description = "Zone ID của ALB."
  value       = aws_lb.main_alb.zone_id
}