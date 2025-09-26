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

output "nlb_listener_arn" {
  description = "ARN of the NLB listener for API Gateway integration"
  value       = module.nlb.nlb_listener_arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.new-vpc.vpc_cidr_block
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = var.cluster_name
}

output "private_subnet_ids" {
  description = "Private subnet IDs for VPC Link"
  value       = module.new-vpc.private_subnet_ids
}

output "vpc_link_security_group_id" {
  description = "Security Group ID for VPC Link"
  value       = module.nlb.vpc_link_security_group_id
}