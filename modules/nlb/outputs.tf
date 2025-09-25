output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = try(data.aws_lb.kubernetes_nlb.arn, aws_lb.golang_api_nlb[0].arn)
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = try(data.aws_lb.kubernetes_nlb.dns_name, aws_lb.golang_api_nlb[0].dns_name)
}

output "nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer"
  value       = try(data.aws_lb.kubernetes_nlb.zone_id, aws_lb.golang_api_nlb[0].zone_id)
}