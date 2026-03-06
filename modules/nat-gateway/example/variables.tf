variable "namespace" {
  description = "Namespace (organization/team name)"
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "name" {
  description = "Name of the NAT Gateway"
  type        = string
  default     = "ha"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "AZ count must be between 2 and 3 for high availability"
  }
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Example = "ha-nat-gateway"
  }
}
