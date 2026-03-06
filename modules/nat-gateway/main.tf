# NAT Gateway Module
# Creates NAT Gateway with Internet Gateway for private subnet internet access

# Internet Gateway (required for NAT Gateway)
resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "${local.nat_gateway_name}-igw"
    }
  )
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.public_subnet_ids) : 0

  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${local.nat_gateway_name}-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? length(var.public_subnet_ids) : 0

  allocation_id     = aws_eip.nat[count.index].id
  subnet_id         = var.public_subnet_ids[count.index]
  connectivity_type = var.connectivity_type

  tags = merge(
    local.tags,
    {
      Name = "${local.nat_gateway_name}-${count.index + 1}"
      AZ   = data.aws_subnet.public[count.index].availability_zone
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# Data source to get subnet availability zones
data "aws_subnet" "public" {
  count = var.enable_nat_gateway ? length(var.public_subnet_ids) : 0
  id    = var.public_subnet_ids[count.index]
}
