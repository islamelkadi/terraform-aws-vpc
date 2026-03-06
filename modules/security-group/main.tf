# Security Group Module
# Creates AWS Security Group with configurable ingress and egress rules

# Validation checks
check "security_group_validation" {
  assert {
    condition     = !local.has_public_ingress || var.allow_public_ingress
    error_message = "Ingress rules cannot use 0.0.0.0/0 or ::/0 by default. Set allow_public_ingress=true to explicitly allow public access."
  }
}

resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = var.description
  vpc_id      = var.vpc_id

  tags = local.tags
}

# Ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description

  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol

  # Source can be CIDR blocks, security groups, or prefix lists
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
}

# Egress rules
resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type              = "egress"
  security_group_id = aws_security_group.this.id
  description       = each.value.description

  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol

  # Destination can be CIDR blocks, security groups, or prefix lists
  # Note: AWS uses source_security_group_id for both ingress and egress
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
}
