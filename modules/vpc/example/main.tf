module "vpc" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  cidr_block = var.cidr_block
  az_count   = var.az_count

  # Subnet CIDRs will be auto-generated based on CIDR block and AZ count:
  # Public: 10.0.0.0/24, 10.0.1.0/24
  # Private: 10.0.10.0/24, 10.0.11.0/24
  # Database: 10.0.20.0/24, 10.0.21.0/24

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_flow_logs         = var.enable_flow_logs
  flow_logs_retention_days = var.flow_logs_retention_days

  tags = var.tags
}
