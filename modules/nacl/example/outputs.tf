# Example Outputs

output "nacl_id" {
  description = "Network ACL ID"
  value       = module.private_nacl.id
}

output "nacl_arn" {
  description = "Network ACL ARN"
  value       = module.private_nacl.arn
}

output "nacl_name" {
  description = "Network ACL name"
  value       = module.private_nacl.name
}
