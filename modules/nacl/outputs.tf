# Network ACL Module Outputs

output "id" {
  description = "Network ACL ID"
  value       = aws_network_acl.this.id
}

output "arn" {
  description = "Network ACL ARN"
  value       = aws_network_acl.this.arn
}

output "name" {
  description = "Network ACL name"
  value       = local.nacl_name
}

output "vpc_id" {
  description = "VPC ID where the network ACL is created"
  value       = aws_network_acl.this.vpc_id
}

output "subnet_ids" {
  description = "List of subnet IDs associated with the network ACL"
  value       = aws_network_acl.this.subnet_ids
}

output "tags" {
  description = "Tags applied to the network ACL"
  value       = aws_network_acl.this.tags
}

output "inbound_rules" {
  description = "Inbound rules applied to the network ACL"
  value       = aws_network_acl_rule.inbound
}

output "outbound_rules" {
  description = "Outbound rules applied to the network ACL"
  value       = aws_network_acl_rule.outbound
}
