# Network ACL Module Variables

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
  description = "Name of the network ACL"
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

# Network ACL specific variables
variable "vpc_id" {
  description = "VPC ID where the network ACL will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the network ACL"
  type        = list(string)
  default     = []
}

variable "inbound_rules" {
  description = "List of inbound NACL rules. Each rule must have a unique rule_number"
  type = list(object({
    rule_number     = number
    protocol        = string
    rule_action     = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    from_port       = optional(number)
    to_port         = optional(number)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.inbound_rules :
      rule.rule_number >= 1 && rule.rule_number <= 32766
    ])
    error_message = "Rule numbers must be between 1 and 32766"
  }

  validation {
    condition = alltrue([
      for rule in var.inbound_rules :
      contains(["allow", "deny"], rule.rule_action)
    ])
    error_message = "Rule action must be 'allow' or 'deny'"
  }

  validation {
    condition = alltrue([
      for rule in var.inbound_rules :
      rule.cidr_block != null || rule.ipv6_cidr_block != null
    ])
    error_message = "Each rule must specify either cidr_block or ipv6_cidr_block"
  }
}

variable "outbound_rules" {
  description = "List of outbound NACL rules. Each rule must have a unique rule_number"
  type = list(object({
    rule_number     = number
    protocol        = string
    rule_action     = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    from_port       = optional(number)
    to_port         = optional(number)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.outbound_rules :
      rule.rule_number >= 1 && rule.rule_number <= 32766
    ])
    error_message = "Rule numbers must be between 1 and 32766"
  }

  validation {
    condition = alltrue([
      for rule in var.outbound_rules :
      contains(["allow", "deny"], rule.rule_action)
    ])
    error_message = "Rule action must be 'allow' or 'deny'"
  }

  validation {
    condition = alltrue([
      for rule in var.outbound_rules :
      rule.cidr_block != null || rule.ipv6_cidr_block != null
    ])
    error_message = "Each rule must specify either cidr_block or ipv6_cidr_block"
  }
}

variable "enable_default_deny" {
  description = "Enable default deny-all rules at rule number 32767 (lowest priority). Set to false if you want to manage all rules explicitly"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}
