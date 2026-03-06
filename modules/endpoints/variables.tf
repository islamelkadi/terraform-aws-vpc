variable "vpc_id" {
  description = "ID of the VPC where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for interface endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "List of route table IDs for gateway endpoints"
  type        = list(string)
  default     = []
}

variable "enable_s3_endpoint" {
  description = "Enable S3 Gateway endpoint (no data transfer costs)"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB Gateway endpoint (no data transfer costs)"
  type        = bool
  default     = true
}

variable "enable_secrets_manager_endpoint" {
  description = "Enable Secrets Manager interface endpoint"
  type        = bool
  default     = true
}

variable "enable_ssm_endpoint" {
  description = "Enable SSM Parameter Store interface endpoint"
  type        = bool
  default     = true
}

variable "enable_bedrock_endpoint" {
  description = "Enable Bedrock interface endpoint"
  type        = bool
  default     = true
}

variable "enable_bedrock_runtime_endpoint" {
  description = "Enable Bedrock Runtime interface endpoint"
  type        = bool
  default     = true
}

variable "enable_bedrock_agent_endpoint" {
  description = "Enable Bedrock Agent interface endpoint"
  type        = bool
  default     = true
}

variable "enable_bedrock_agent_runtime_endpoint" {
  description = "Enable Bedrock Agent Runtime interface endpoint"
  type        = bool
  default     = true
}

variable "enable_step_functions_endpoint" {
  description = "Enable Step Functions interface endpoint"
  type        = bool
  default     = true
}

variable "enable_logs_endpoint" {
  description = "Enable CloudWatch Logs interface endpoint"
  type        = bool
  default     = true
}

variable "enable_private_dns" {
  description = "Enable private DNS for interface endpoints"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs for interface endpoints. If not provided, a default security group will be created"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access interface endpoints (used if security_group_ids is empty)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "Namespace for resource naming (e.g., organization name)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name for the VPC endpoints module"
  type        = string
  default     = "vpc-endpoints"
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}
