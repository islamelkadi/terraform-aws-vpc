# Security Group Module Variables

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
  description = "Name of the security group"
  type        = string
}

variable "attributes" {
  description = "Additional attributes for naming"
  type        = list(string)
  default     = []
}

variable "delimiter" {
  description = "Delimiter to use between name components"
  type        = string
  default     = "-"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Security Group specific variables
variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules. Each rule must have a description and cannot use 0.0.0.0/0 by default (set allow_public_ingress=true to override)"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    source_security_group_id = optional(string)
    prefix_list_ids          = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules : rule.description != null && rule.description != ""
    ])
    error_message = "All ingress rules must have a non-empty description"
  }
}

variable "egress_rules" {
  description = "List of egress rules. Each rule must have a description"
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    source_security_group_id = optional(string)
    prefix_list_ids          = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules : rule.description != null && rule.description != ""
    ])
    error_message = "All egress rules must have a non-empty description"
  }
}

variable "allow_public_ingress" {
  description = "Explicitly allow ingress rules with 0.0.0.0/0 or ::/0. Set to true only when public access is required"
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}
