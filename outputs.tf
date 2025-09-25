output "vpc_id" {
  description = "VPC ID"
  value       = module.new-vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = module.new-vpc.subnet_ids
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer for API Gateway VPC Link"
  value       = module.nlb.nlb_arn
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.nlb.nlb_dns_name
}