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