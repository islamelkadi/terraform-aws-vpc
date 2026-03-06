locals {
  # Create security group if none provided
  create_security_group = length(var.security_group_ids) == 0

  # Use provided security groups or the created one
  endpoint_security_group_ids = local.create_security_group ? [aws_security_group.endpoints[0].id] : var.security_group_ids

  # Name prefix for resources
  name_prefix = var.namespace != "" && var.environment != "" ? "${var.namespace}-${var.environment}-${var.name}" : var.name

  # Common tags - consistent pattern with other modules
  common_tags = merge(
    var.tags,
    module.metadata.security_tags,
    {
      Module = "terraform-aws-vpc/endpoints"
    }
  )
}
