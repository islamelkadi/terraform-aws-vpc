# Local values for validation and processing

locals {
  # Construct network ACL name from components
  name_parts = compact(concat(
    [var.namespace],
    [var.environment],
    [var.name],
    var.attributes
  ))

  nacl_name = join(var.delimiter, local.name_parts)

  # Merge tags with defaults
  tags = merge(
    var.tags,
    module.metadata.security_tags,
    {
      Name   = local.nacl_name
      Module = "terraform-aws-nacl"
    }
  )

  # Collect all rule numbers from both inbound and outbound rules
  inbound_rule_numbers  = [for rule in var.inbound_rules : rule.rule_number]
  outbound_rule_numbers = [for rule in var.outbound_rules : rule.rule_number]

  # Check for duplicate rule numbers within each direction (inbound and outbound are separate)
  unique_inbound_rule_numbers  = distinct(local.inbound_rule_numbers)
  unique_outbound_rule_numbers = distinct(local.outbound_rule_numbers)

  has_duplicate_inbound_rules  = length(local.inbound_rule_numbers) != length(local.unique_inbound_rule_numbers)
  has_duplicate_outbound_rules = length(local.outbound_rule_numbers) != length(local.unique_outbound_rule_numbers)
  has_duplicate_rules          = local.has_duplicate_inbound_rules || local.has_duplicate_outbound_rules

  # Check if any rule uses reserved rule number 32767 (used for default deny)
  has_reserved_rule_number = var.enable_default_deny && (
    anytrue([for rule_num in local.inbound_rule_numbers : rule_num == 32767]) ||
    anytrue([for rule_num in local.outbound_rule_numbers : rule_num == 32767])
  )
}
