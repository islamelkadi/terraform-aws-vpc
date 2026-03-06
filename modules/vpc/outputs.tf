# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = local.availability_zones
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database[*].arn
}

output "database_subnet_cidrs" {
  description = "List of CIDR blocks of database subnets"
  value       = aws_subnet.database[*].cidr_block
}

output "database_subnet_group_name" {
  description = "Name of database subnet group"
  value       = try(aws_db_subnet_group.this[0].name, null)
}

output "database_subnet_group_id" {
  description = "ID of database subnet group"
  value       = try(aws_db_subnet_group.this[0].id, null)
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, null)
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# Route Table Outputs
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = aws_route_table.database[*].id
}

# VPC Flow Logs Outputs
output "flow_logs_id" {
  description = "The ID of the VPC Flow Log"
  value       = try(aws_flow_log.this[0].id, null)
}

output "flow_logs_log_group_name" {
  description = "The name of the CloudWatch Log Group for VPC Flow Logs"
  value       = try(aws_cloudwatch_log_group.flow_logs[0].name, null)
}

output "flow_logs_log_group_arn" {
  description = "The ARN of the CloudWatch Log Group for VPC Flow Logs"
  value       = try(aws_cloudwatch_log_group.flow_logs[0].arn, null)
}
