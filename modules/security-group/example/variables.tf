variable "namespace" {
  description = "Namespace (organization/team name)"
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Name of the security group"
  type        = string
  default     = "lambda"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  default     = "vpc-0a1b2c3d4e5f67890"
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for Lambda functions"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Project = "EXAMPLE"
    Example = "BASIC"
  }
}
