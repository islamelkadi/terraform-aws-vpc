# Security Group Example Outputs

output "lambda_security_group_id" {
  description = "Lambda security group ID"
  value       = module.lambda_security_group.id
}

output "lambda_security_group_arn" {
  description = "Lambda security group ARN"
  value       = module.lambda_security_group.arn
}
