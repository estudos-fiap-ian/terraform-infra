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
  value       = aws_lb_listener.golang_api_listener_8080.arn
}