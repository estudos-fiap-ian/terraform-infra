terraform {
  required_providers {
    aws   = ">=6.10.0"
    local = ">=2.5.3"
  }
  backend "s3" {
    bucket = "bucket-s3-ian-fiap"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "new-vpc" {
  source         = "./modules/vpc"
  prefix         = var.prefix
  vpc_cidr_block = var.vpc_cidr_block
}

module "eks" {
  source             = "./modules/eks"
  prefix             = var.prefix
  subnet_ids         = module.new-vpc.subnet_ids
  vpc_id             = module.new-vpc.vpc_id
  cluster_name       = var.cluster_name
  desired_size       = var.desired_size
  max_size           = var.max_size
  minimum_size       = var.minimum_size
  log_retention_days = var.log_retention_days
}

module "nlb" {
  source       = "./modules/nlb"
  prefix       = var.prefix
  vpc_id       = module.new-vpc.vpc_id
  subnet_ids   = module.new-vpc.subnet_ids
  cluster_name = var.cluster_name
}
