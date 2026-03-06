# NAT Gateway Module Outputs

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs associated with NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "nat_gateway_private_ips" {
  description = "List of private IPs associated with NAT Gateways"
  value       = aws_nat_gateway.this[*].private_ip
}

output "nat_gateway_network_interface_ids" {
  description = "List of ENI IDs associated with NAT Gateways"
  value       = aws_nat_gateway.this[*].network_interface_id
}

output "elastic_ip_ids" {
  description = "List of Elastic IP allocation IDs"
  value       = aws_eip.nat[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = var.create_internet_gateway ? aws_internet_gateway.this[0].id : var.internet_gateway_id
}

output "internet_gateway_arn" {
  description = "ARN of the Internet Gateway"
  value       = var.create_internet_gateway ? aws_internet_gateway.this[0].arn : null
}

output "availability_zones" {
  description = "List of availability zones where NAT Gateways are deployed"
  value       = data.aws_subnet.public[*].availability_zone
}

output "tags" {
  description = "Tags applied to NAT Gateway resources"
  value       = local.tags
}
