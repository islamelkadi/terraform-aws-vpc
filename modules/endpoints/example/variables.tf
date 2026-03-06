variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "namespace" {
  description = "Namespace for resource naming"
  type        = string
  default     = "example-org"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Name for the VPC endpoints module"
  type        = string
  default     = "vpc-endpoints"
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
  default     = "vpc-0a1b2c3d4e5f67890"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for interface endpoints"
  type        = list(string)
  default     = ["subnet-0a1b2c3d4e5f00001", "subnet-0a1b2c3d4e5f00002"]
}

variable "route_table_ids" {
  description = "List of route table IDs for gateway endpoints"
  type        = list(string)
  default     = ["rtb-0a1b2c3d4e5f00001", "rtb-0a1b2c3d4e5f00002"]
}

variable "enable_s3_endpoint" {
  description = "Enable S3 Gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB Gateway endpoint"
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

variable "enable_bedrock_runtime_endpoint" {
  description = "Enable Bedrock Runtime interface endpoint"
  type        = bool
  default     = true
}

variable "enable_logs_endpoint" {
  description = "Enable CloudWatch Logs interface endpoint"
  type        = bool
  default     = true
}

variable "enable_bedrock_endpoint" {
  description = "Enable Bedrock interface endpoint"
  type        = bool
  default     = false
}

variable "enable_bedrock_agent_endpoint" {
  description = "Enable Bedrock Agent interface endpoint"
  type        = bool
  default     = false
}

variable "enable_bedrock_agent_runtime_endpoint" {
  description = "Enable Bedrock Agent Runtime interface endpoint"
  type        = bool
  default     = false
}

variable "enable_step_functions_endpoint" {
  description = "Enable Step Functions interface endpoint"
  type        = bool
  default     = false
}

variable "enable_private_dns" {
  description = "Enable private DNS for interface endpoints"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default = {
    Example = "vpc-endpoints-basic"
  }
}
