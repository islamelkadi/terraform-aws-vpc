# Local values for NAT Gateway module

locals {
  nat_gateway_name = module.metadata.resource_prefix

  tags = merge(
    var.tags,
    module.metadata.security_tags,
    {
      Name   = local.nat_gateway_name
      Module = "terraform-aws-vpc/nat-gateway"
    }
  )
}
