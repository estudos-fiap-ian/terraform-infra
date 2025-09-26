variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "grupo-275"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "grupo-275-cluster-ian"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "desired_size" {
  description = "Desired number of nodes in EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes in EKS node group"
  type        = number
  default     = 4
}

variable "minimum_size" {
  description = "Minimum number of nodes in EKS node group"
  type        = number
  default     = 1
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
