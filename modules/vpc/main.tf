# VPC Resource
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Module    = "terraform-aws-vpc"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(local.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-public-${local.availability_zones[count.index]}"
      Type      = "public"
      ManagedBy = "Terraform"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(local.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-private-${local.availability_zones[count.index]}"
      Type      = "private"
      ManagedBy = "Terraform"
    }
  )
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(local.database_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.database_subnet_cidrs[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-database-${local.availability_zones[count.index]}"
      Type      = "database"
      ManagedBy = "Terraform"
    }
  )
}

# Database Subnet Group for RDS
resource "aws_db_subnet_group" "this" {
  count = length(local.database_subnet_cidrs) > 0 ? 1 : 0

  name       = "${var.name}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-db-subnet-group"
      ManagedBy = "Terraform"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count = length(local.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-igw"
      ManagedBy = "Terraform"
    }
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(local.public_subnet_cidrs)) : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name      = var.single_nat_gateway ? "${var.name}-nat-eip" : "${var.name}-nat-eip-${local.availability_zones[count.index]}"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(local.public_subnet_cidrs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    {
      Name      = var.single_nat_gateway ? "${var.name}-nat" : "${var.name}-nat-${local.availability_zones[count.index]}"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  count = length(local.public_subnet_cidrs) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-public-rt"
      Type      = "public"
      ManagedBy = "Terraform"
    }
  )
}

# Public Route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  count = length(local.public_subnet_cidrs) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(local.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Private Route Tables (one per AZ for high availability)
resource "aws_route_table" "private" {
  count = length(local.private_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-private-rt-${local.availability_zones[count.index]}"
      Type      = "private"
      ManagedBy = "Terraform"
    }
  )
}

# Private Routes to NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? length(local.private_subnet_cidrs) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = length(local.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Database Route Tables (one per AZ)
resource "aws_route_table" "database" {
  count = length(local.database_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-database-rt-${local.availability_zones[count.index]}"
      Type      = "database"
      ManagedBy = "Terraform"
    }
  )
}

# Database Routes to NAT Gateway (optional, for updates/patches)
resource "aws_route" "database_nat_gateway" {
  count = var.enable_nat_gateway ? length(local.database_subnet_cidrs) : 0

  route_table_id         = aws_route_table.database[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

# Database Route Table Associations
resource "aws_route_table_association" "database" {
  count = length(local.database_subnet_cidrs)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  
  name              = "/aws/vpc/${var.name}-flow-logs"
  retention_in_days = var.flow_logs_retention_days
  
  tags = merge(
    var.tags,
    {
      Name = "/aws/vpc/${var.name}-flow-logs"
    }
  )
}

# IAM Role for VPC Flow Logs
data "aws_iam_policy_document" "flow_logs_assume" {
  count = var.enable_flow_logs ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "flow_logs_policy" {
  count = var.enable_flow_logs ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      aws_cloudwatch_log_group.flow_logs[0].arn,
      "${aws_cloudwatch_log_group.flow_logs[0].arn}:*"
    ]
  }
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name               = "${var.name}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume[0].json

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-vpc-flow-logs-role"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_iam_role_policy" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name   = "${var.name}-vpc-flow-logs-policy"
  role   = aws_iam_role.flow_logs[0].id
  policy = data.aws_iam_policy_document.flow_logs_policy[0].json
}

# VPC Flow Logs
resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn    = aws_iam_role.flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.flow_logs[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-flow-logs"
      ManagedBy = "Terraform"
    }
  )
}
