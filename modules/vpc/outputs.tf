output "vpc_id" {
  value = aws_vpc.new-vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.new-vpc.cidr_block
}

output "private_subnet_ids" {
  description = "Private subnet IDs (using public subnets as we don't have separate private ones)"
  value = aws_subnet.subnets[*].id
}
