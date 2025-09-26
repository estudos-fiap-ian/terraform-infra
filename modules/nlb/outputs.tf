output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = aws_lb.golang_api_nlb.arn
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.golang_api_nlb.dns_name
}

output "nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer"
  value       = aws_lb.golang_api_nlb.zone_id
}

output "nlb_listener_arn" {
  description = "ARN of the NLB listener for API Gateway (port 80)"
  value       = aws_lb_listener.golang_api_listener_80.arn
}

output "nlb_listener_8080_arn" {
  description = "ARN of the NLB listener for direct access (port 8080)"
  value       = aws_lb_listener.golang_api_listener.arn
}

output "vpc_link_security_group_id" {
  description = "Security Group ID for VPC Link"
  value       = aws_security_group.vpc_link_sg.id
}