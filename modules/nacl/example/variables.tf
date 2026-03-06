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
  description = "Name for the network ACL"
  type        = string
  default     = "private-subnets"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the network ACL will be created"
  type        = string
  default     = "vpc-0a1b2c3d4e5f67890"
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the network ACL"
  type        = list(string)
  default     = ["subnet-0a1b2c3d4e5f00001", "subnet-0a1b2c3d4e5f00002"]
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_default_deny" {
  description = "Enable default deny-all rules"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Purpose = "Example"
  }
}
