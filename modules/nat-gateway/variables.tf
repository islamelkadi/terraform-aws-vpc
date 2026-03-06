# NAT Gateway Module Variables

# Metadata variables for consistent naming
variable "namespace" {
  description = "Namespace (organization/team name)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

# NAT Gateway configuration
variable "vpc_id" {
  description = "ID of the VPC where NAT Gateway will be created"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway creation"
  type        = bool
  default     = true
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where NAT Gateways will be created (one per AZ for HA)"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_subnet_ids) > 0
    error_message = "At least one public subnet ID must be provided"
  }
}

variable "connectivity_type" {
  description = "Connectivity type for NAT Gateway (public or private)"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.connectivity_type)
    error_message = "Connectivity type must be either public or private"
  }
}

# Internet Gateway configuration
variable "create_internet_gateway" {
  description = "Create an Internet Gateway for the VPC (required for public NAT Gateway)"
  type        = bool
  default     = true
}

variable "internet_gateway_id" {
  description = "Existing Internet Gateway ID (if create_internet_gateway is false)"
  type        = string
  default     = null
}


