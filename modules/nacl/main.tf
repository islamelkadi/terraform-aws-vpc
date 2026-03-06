# Network ACL Module
# Creates AWS Network ACL with configurable inbound and outbound rules

# Validation checks
check "nacl_rule_validation" {
  assert {
    condition     = !local.has_duplicate_rules
    error_message = "Duplicate rule numbers detected. Each rule must have a unique rule_number."
  }

  assert {
    condition     = !local.has_reserved_rule_number
    error_message = "Rule number 32767 is reserved for default deny-all rules. Use a different rule number or set enable_default_deny=false."
  }
}

resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = local.tags
}

# Inbound rules
resource "aws_network_acl_rule" "inbound" {
  for_each = { for rule in var.inbound_rules : rule.rule_number => rule }

  network_acl_id  = aws_network_acl.this.id
  rule_number     = each.value.rule_number
  egress          = false
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}


# Outbound rules
resource "aws_network_acl_rule" "outbound" {
  for_each = { for rule in var.outbound_rules : rule.rule_number => rule }

  network_acl_id  = aws_network_acl.this.id
  rule_number     = each.value.rule_number
  egress          = true
  protocol        = each.value.protocol
  rule_action     = each.value.rule_action
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}


# Default deny-all inbound rule (lowest priority)
resource "aws_network_acl_rule" "default_deny_inbound" {
  count = var.enable_default_deny ? 1 : 0

  network_acl_id = aws_network_acl.this.id
  rule_number    = 32767
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}

# Default deny-all outbound rule (lowest priority)
resource "aws_network_acl_rule" "default_deny_outbound" {
  count = var.enable_default_deny ? 1 : 0

  network_acl_id = aws_network_acl.this.id
  rule_number    = 32767
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
}
