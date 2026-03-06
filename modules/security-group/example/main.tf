# Basic Security Group Example

module "lambda_security_group" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  vpc_id      = var.vpc_id
  description = var.description

  egress_rules = [
    {
      description = "Allow HTTPS to VPC endpoints"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }
  ]

  tags = var.tags
}
