# High Availability NAT Gateway Example
# Multiple NAT Gateways across availability zones for production

# VPC module
module "vpc" {
  source = "../../vpc"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

  az_count = var.az_count

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false # We'll use the standalone NAT Gateway module
  enable_flow_logs     = false # Simplified for example

  tags = var.tags
}

# NAT Gateway module (creates one NAT Gateway per public subnet)
module "nat_gateway" {
  source = "./.."

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  tags = var.tags
}

# Update private route tables to use NAT Gateways
# Each private subnet uses NAT Gateway in same AZ
resource "aws_route" "private_nat_gateway" {
  count = var.az_count

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_ids[count.index]
}
