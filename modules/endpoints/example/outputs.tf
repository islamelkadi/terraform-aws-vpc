# Example Outputs

output "gateway_endpoint_ids" {
  description = "Map of gateway endpoint IDs"
  value       = module.vpc_endpoints.gateway_endpoint_ids
}

output "interface_endpoint_ids" {
  description = "Map of interface endpoint IDs"
  value       = module.vpc_endpoints.interface_endpoint_ids
}

output "security_group_id" {
  description = "ID of the security group for interface endpoints"
  value       = module.vpc_endpoints.security_group_id
}
