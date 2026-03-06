# Security Group Module Outputs

output "id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "arn" {
  description = "Security group ARN"
  value       = aws_security_group.this.arn
}

output "name" {
  description = "Security group name"
  value       = aws_security_group.this.name
}

output "vpc_id" {
  description = "VPC ID where the security group is created"
  value       = aws_security_group.this.vpc_id
}

output "tags" {
  description = "Tags applied to the security group"
  value       = aws_security_group.this.tags
}

output "ingress_rules" {
  description = "Ingress rules applied to the security group"
  value       = aws_security_group_rule.ingress
}

output "egress_rules" {
  description = "Egress rules applied to the security group"
  value       = aws_security_group_rule.egress
}
