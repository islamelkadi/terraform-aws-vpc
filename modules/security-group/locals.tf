# Local values for validation and processing

locals {
  # Construct security group name from components
  name_parts = compact(concat(
    [var.namespace],
    [var.environment],
    [var.name],
    var.attributes
  ))

  security_group_name = join(var.delimiter, local.name_parts)

  # Merge tags with defaults
  tags = merge(
    var.tags,
    module.metadata.security_tags,
    {
      Name   = local.security_group_name
      Module = "terraform-aws-security-group"
    }
  )

  # Check if any ingress rule contains public CIDR blocks
  has_public_ingress = anytrue([
    for rule in var.ingress_rules :
    contains(coalesce(lookup(rule, "cidr_blocks", null), []), "0.0.0.0/0") ||
    contains(coalesce(lookup(rule, "ipv6_cidr_blocks", null), []), "::/0")
  ])
}
