# Local values for AZ selection
locals {
  # Use specified AZs if provided, otherwise auto-select based on az_count
  availability_zones = var.availability_zones != null ? var.availability_zones : slice(module.metadata.availability_zones, 0, var.az_count)

  # Calculate the number of AZs to use
  az_count = var.availability_zones != null ? length(var.availability_zones) : var.az_count

  # Auto-generate subnet CIDRs if not provided
  public_subnet_cidrs = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.cidr_block, 8, idx)
  ]

  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.cidr_block, 8, idx + 10)
  ]

  database_subnet_cidrs = length(var.database_subnet_cidrs) > 0 ? var.database_subnet_cidrs : [
    for idx in range(local.az_count) : cidrsubnet(var.cidr_block, 8, idx + 20)
  ]
}
