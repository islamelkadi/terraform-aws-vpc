output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.nat_gateway.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "List of NAT Gateway public IPs"
  value       = module.nat_gateway.nat_gateway_public_ips
}

output "availability_zones" {
  description = "Availability zones where NAT Gateways are deployed"
  value       = module.nat_gateway.availability_zones
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.nat_gateway.internet_gateway_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_mapping" {
  description = "Mapping of AZ to NAT Gateway details"
  value = {
    for idx, az in module.nat_gateway.availability_zones : az => {
      nat_gateway_id = module.nat_gateway.nat_gateway_ids[idx]
      public_ip      = module.nat_gateway.nat_gateway_public_ips[idx]
      public_subnet  = module.vpc.public_subnet_ids[idx]
      private_subnet = module.vpc.private_subnet_ids[idx]
    }
  }
}
