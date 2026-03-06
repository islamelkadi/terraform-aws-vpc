# Security Group Outputs
output "security_group_id" {
  description = "ID of the security group created for interface endpoints"
  value       = local.create_security_group ? aws_security_group.endpoints[0].id : null
}

output "security_group_arn" {
  description = "ARN of the security group created for interface endpoints"
  value       = local.create_security_group ? aws_security_group.endpoints[0].arn : null
}

# Gateway Endpoint Outputs
output "s3_endpoint_id" {
  description = "ID of the S3 Gateway endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "s3_endpoint_prefix_list_id" {
  description = "Prefix list ID of the S3 Gateway endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].prefix_list_id : null
}

output "dynamodb_endpoint_id" {
  description = "ID of the DynamoDB Gateway endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "dynamodb_endpoint_prefix_list_id" {
  description = "Prefix list ID of the DynamoDB Gateway endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].prefix_list_id : null
}

# Interface Endpoint Outputs
output "secrets_manager_endpoint_id" {
  description = "ID of the Secrets Manager interface endpoint"
  value       = var.enable_secrets_manager_endpoint ? aws_vpc_endpoint.secrets_manager[0].id : null
}

output "secrets_manager_endpoint_dns_entries" {
  description = "DNS entries for the Secrets Manager interface endpoint"
  value       = var.enable_secrets_manager_endpoint ? aws_vpc_endpoint.secrets_manager[0].dns_entry : []
}

output "ssm_endpoint_id" {
  description = "ID of the SSM Parameter Store interface endpoint"
  value       = var.enable_ssm_endpoint ? aws_vpc_endpoint.ssm[0].id : null
}

output "ssm_endpoint_dns_entries" {
  description = "DNS entries for the SSM Parameter Store interface endpoint"
  value       = var.enable_ssm_endpoint ? aws_vpc_endpoint.ssm[0].dns_entry : []
}

output "bedrock_endpoint_id" {
  description = "ID of the Bedrock interface endpoint"
  value       = var.enable_bedrock_endpoint ? aws_vpc_endpoint.bedrock[0].id : null
}

output "bedrock_endpoint_dns_entries" {
  description = "DNS entries for the Bedrock interface endpoint"
  value       = var.enable_bedrock_endpoint ? aws_vpc_endpoint.bedrock[0].dns_entry : []
}

output "bedrock_runtime_endpoint_id" {
  description = "ID of the Bedrock Runtime interface endpoint"
  value       = var.enable_bedrock_runtime_endpoint ? aws_vpc_endpoint.bedrock_runtime[0].id : null
}

output "bedrock_runtime_endpoint_dns_entries" {
  description = "DNS entries for the Bedrock Runtime interface endpoint"
  value       = var.enable_bedrock_runtime_endpoint ? aws_vpc_endpoint.bedrock_runtime[0].dns_entry : []
}

output "bedrock_agent_endpoint_id" {
  description = "ID of the Bedrock Agent interface endpoint"
  value       = var.enable_bedrock_agent_endpoint ? aws_vpc_endpoint.bedrock_agent[0].id : null
}

output "bedrock_agent_endpoint_dns_entries" {
  description = "DNS entries for the Bedrock Agent interface endpoint"
  value       = var.enable_bedrock_agent_endpoint ? aws_vpc_endpoint.bedrock_agent[0].dns_entry : []
}

output "bedrock_agent_runtime_endpoint_id" {
  description = "ID of the Bedrock Agent Runtime interface endpoint"
  value       = var.enable_bedrock_agent_runtime_endpoint ? aws_vpc_endpoint.bedrock_agent_runtime[0].id : null
}

output "bedrock_agent_runtime_endpoint_dns_entries" {
  description = "DNS entries for the Bedrock Agent Runtime interface endpoint"
  value       = var.enable_bedrock_agent_runtime_endpoint ? aws_vpc_endpoint.bedrock_agent_runtime[0].dns_entry : []
}

output "step_functions_endpoint_id" {
  description = "ID of the Step Functions interface endpoint"
  value       = var.enable_step_functions_endpoint ? aws_vpc_endpoint.states[0].id : null
}

output "step_functions_endpoint_dns_entries" {
  description = "DNS entries for the Step Functions interface endpoint"
  value       = var.enable_step_functions_endpoint ? aws_vpc_endpoint.states[0].dns_entry : []
}

output "logs_endpoint_id" {
  description = "ID of the CloudWatch Logs interface endpoint"
  value       = var.enable_logs_endpoint ? aws_vpc_endpoint.logs[0].id : null
}

output "logs_endpoint_dns_entries" {
  description = "DNS entries for the CloudWatch Logs interface endpoint"
  value       = var.enable_logs_endpoint ? aws_vpc_endpoint.logs[0].dns_entry : []
}

# Summary Outputs
output "gateway_endpoint_ids" {
  description = "Map of gateway endpoint IDs"
  value = {
    s3       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
    dynamodb = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
  }
}

output "interface_endpoint_ids" {
  description = "Map of interface endpoint IDs"
  value = {
    secrets_manager       = var.enable_secrets_manager_endpoint ? aws_vpc_endpoint.secrets_manager[0].id : null
    ssm                   = var.enable_ssm_endpoint ? aws_vpc_endpoint.ssm[0].id : null
    bedrock               = var.enable_bedrock_endpoint ? aws_vpc_endpoint.bedrock[0].id : null
    bedrock_runtime       = var.enable_bedrock_runtime_endpoint ? aws_vpc_endpoint.bedrock_runtime[0].id : null
    bedrock_agent         = var.enable_bedrock_agent_endpoint ? aws_vpc_endpoint.bedrock_agent[0].id : null
    bedrock_agent_runtime = var.enable_bedrock_agent_runtime_endpoint ? aws_vpc_endpoint.bedrock_agent_runtime[0].id : null
    step_functions        = var.enable_step_functions_endpoint ? aws_vpc_endpoint.states[0].id : null
    logs                  = var.enable_logs_endpoint ? aws_vpc_endpoint.logs[0].id : null
  }
}
