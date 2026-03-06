output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = module.vpc.availability_zones
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "nat_gateway_public_ips" {
  description = "List of public IPs for NAT Gateways"
  value       = module.vpc.nat_gateway_public_ips
}
