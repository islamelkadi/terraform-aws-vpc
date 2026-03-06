# Basic Network ACL Example

module "private_nacl" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  inbound_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = var.vpc_cidr_block
    }
  ]

  outbound_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = var.vpc_cidr_block
    }
  ]

  enable_default_deny = var.enable_default_deny

  tags = var.tags
}
