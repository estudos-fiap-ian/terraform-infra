# GitHub Actions Setup for Terraform Infrastructure

## Required GitHub Secrets

You need to configure the following secrets in your GitHub repository:

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following repository secrets:

### AWS Credentials
- `AWS_ACCESS_KEY_ID` - Your AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY` - Your AWS Secret Access Key

**Important:** These credentials need permissions to:
- Create/manage VPC resources
- Create/manage EKS clusters
- Access S3 bucket `bucket-s3-ian-fiap` for Terraform state
- Manage IAM roles and policies for EKS

## How the Workflow Works

### On Pull Request:
- Runs `terraform fmt -check` to validate formatting
- Initializes Terraform and validates configuration
- Creates a plan and posts results as a PR comment
- Does NOT apply changes

### On Push to Main Branch:
- Runs all validation steps
- Automatically applies Terraform changes with `terraform apply -auto-approve`

## AWS Permissions Required

Your AWS credentials need the following managed policies (minimum):
- `AmazonVPCFullAccess`
- `AmazonEKSClusterPolicy`
- `AmazonEKSServicePolicy`
- `AmazonEKSWorkerNodePolicy`
- `AmazonEKS_CNI_Policy`
- `AmazonEC2ContainerRegistryReadOnly`
- `AmazonS3FullAccess` (for state bucket access)
 
But in AWS Academy you can use LabRole role!

Or create a custom policy with specific permissions for your resources.

## Workflow Triggers

The workflow runs on:
- **Push to main branch** → Validates and applies infrastructure
- **Pull request to main** → Validates and shows plan in PR comments

## State Management

- Terraform state is stored in S3 bucket: `bucket-s3-ian-fiap`
- State file: `terraform.tfstate`
- Region: `us-east-1`

Make sure the S3 bucket exists and your AWS credentials have access to it.