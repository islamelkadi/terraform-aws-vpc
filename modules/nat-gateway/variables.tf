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


# Security Controls
variable "security_controls" {
  description = "Security controls configuration from metadata module"
  type = object({
    encryption = optional(object({
      require_kms_customer_managed  = optional(bool, false)
      require_encryption_at_rest    = optional(bool, false)
      require_encryption_in_transit = optional(bool, false)
      enable_kms_key_rotation       = optional(bool, false)
    }), {})
    logging = optional(object({
      require_cloudwatch_logs = optional(bool, false)
      min_log_retention_days  = optional(number, 1)
      require_access_logging  = optional(bool, false)
      require_flow_logs       = optional(bool, false)
    }), {})
    monitoring = optional(object({
      enable_xray_tracing         = optional(bool, false)
      enable_enhanced_monitoring  = optional(bool, false)
      enable_performance_insights = optional(bool, false)
      require_cloudtrail          = optional(bool, false)
    }), {})
    network = optional(object({
      require_private_subnets = optional(bool, false)
      require_vpc_endpoints   = optional(bool, false)
      block_public_ingress    = optional(bool, false)
      require_imdsv2          = optional(bool, false)
    }), {})
    compliance = optional(object({
      enable_point_in_time_recovery = optional(bool, false)
      require_reserved_concurrency  = optional(bool, false)
      enable_deletion_protection    = optional(bool, false)
    }), {})
  })
  default = null
}

variable "security_control_overrides" {
  description = "Security control overrides with justification for audit compliance"
  type = object({
    disable_high_availability = optional(bool, false)
    justification            = optional(string, "")
  })
  default = {
    disable_high_availability = false
    justification            = ""
  }
}