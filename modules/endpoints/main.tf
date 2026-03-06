# Security Group for Interface Endpoints
resource "aws_security_group" "endpoints" {
  count = local.create_security_group ? 1 : 0

  name_prefix = "${local.name_prefix}-endpoints-"
  description = "Security group for VPC interface endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = length(var.allowed_cidr_blocks) > 0 ? var.allowed_cidr_blocks : [data.aws_vpc.selected.cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-endpoints-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Gateway Endpoints (No data transfer costs)

# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${module.metadata.region_name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-gateway"
    }
  )
}

# DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${module.metadata.region_name}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-dynamodb-gateway"
    }
  )
}

# Interface Endpoints

# Secrets Manager Interface Endpoint
resource "aws_vpc_endpoint" "secrets_manager" {
  count = var.enable_secrets_manager_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-secretsmanager"
    }
  )
}

# SSM Parameter Store Interface Endpoint
resource "aws_vpc_endpoint" "ssm" {
  count = var.enable_ssm_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssm"
    }
  )
}

# Bedrock Interface Endpoint
resource "aws_vpc_endpoint" "bedrock" {
  count = var.enable_bedrock_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.bedrock"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bedrock"
    }
  )
}

# Bedrock Runtime Interface Endpoint
resource "aws_vpc_endpoint" "bedrock_runtime" {
  count = var.enable_bedrock_runtime_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.bedrock-runtime"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bedrock-runtime"
    }
  )
}

# Bedrock Agent Interface Endpoint
resource "aws_vpc_endpoint" "bedrock_agent" {
  count = var.enable_bedrock_agent_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.bedrock-agent"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bedrock-agent"
    }
  )
}

# Bedrock Agent Runtime Interface Endpoint
resource "aws_vpc_endpoint" "bedrock_agent_runtime" {
  count = var.enable_bedrock_agent_runtime_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.bedrock-agent-runtime"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-bedrock-agent-runtime"
    }
  )
}

# Step Functions Interface Endpoint
resource "aws_vpc_endpoint" "states" {
  count = var.enable_step_functions_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.states"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-states"
    }
  )
}

# CloudWatch Logs Interface Endpoint
resource "aws_vpc_endpoint" "logs" {
  count = var.enable_logs_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${module.metadata.region_name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = local.endpoint_security_group_ids
  private_dns_enabled = var.enable_private_dns

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-logs"
    }
  )
}
