# Terraform AWS Network ACL Module

Production-ready AWS Network ACL module for subnet-level network filtering. Provides defense-in-depth security with stateless firewall rules for inbound and outbound traffic.

## Table of Contents

- [Features](#features)
- [Usage Example](#usage-example)
- [Requirements](#requirements)

## Features

- **Inbound/Outbound Rules**: Separate rule management for ingress and egress
- **Default Deny**: Optional default deny-all rules for security
- **Rule Prioritization**: Numeric rule ordering (lower numbers evaluated first)
- **Protocol Support**: TCP, UDP, ICMP, and all protocols
- **Subnet Association**: Attach to multiple subnets
- **Consistent Naming**: Integration with metadata module for standardized resource naming

## Security

### Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| Network ACLs | Optional | Recommended | Required |
| Default deny rules | Recommended | Required | Required |
| Rule documentation | Recommended | Required | Required |

For full details on security profiles and how controls vary by environment, see the [Security Profiles](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) documentation.

## Usage Example

```hcl
module "database_nacl" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nacl"
  
  namespace   = "example"
  environment = "prod"
  name        = "database"
  region      = "us-east-1"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.database_subnet_ids
  
  inbound_rules = [
    {
      rule_number = 100
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/16"
      from_port   = 5432
      to_port     = 5432
    }
  ]
  
  outbound_rules = [
    {
      rule_number = 100
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/16"
      from_port   = 1024
      to_port     = 65535
    }
  ]
  
  enable_default_deny = true
  
  tags = {
    Tier = "Data"
  }
}
```

<!-- BEGIN_TF_DOCS -->

## Usage

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.34 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_metadata"></a> [metadata](#module\_metadata) | github.com/islamelkadi/terraform-aws-metadata | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.default_deny_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.default_deny_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes for naming | `list(string)` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to use between name components | `string` | `"-"` | no |
| <a name="input_enable_default_deny"></a> [enable\_default\_deny](#input\_enable\_default\_deny) | Enable default deny-all rules at rule number 32767 (lowest priority). Set to false if you want to manage all rules explicitly | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | List of inbound NACL rules. Each rule must have a unique rule\_number | <pre>list(object({<br/>    rule_number     = number<br/>    protocol        = string<br/>    rule_action     = string<br/>    cidr_block      = optional(string)<br/>    ipv6_cidr_block = optional(string)<br/>    from_port       = optional(number)<br/>    to_port         = optional(number)<br/>    icmp_type       = optional(number)<br/>    icmp_code       = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the network ACL | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | List of outbound NACL rules. Each rule must have a unique rule\_number | <pre>list(object({<br/>    rule_number     = number<br/>    protocol        = string<br/>    rule_action     = string<br/>    cidr_block      = optional(string)<br/>    ipv6_cidr_block = optional(string)<br/>    from_port       = optional(number)<br/>    to_port         = optional(number)<br/>    icmp_type       = optional(number)<br/>    icmp_code       = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to associate with the network ACL | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the network ACL will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Network ACL ARN |
| <a name="output_id"></a> [id](#output\_id) | Network ACL ID |
| <a name="output_inbound_rules"></a> [inbound\_rules](#output\_inbound\_rules) | Inbound rules applied to the network ACL |
| <a name="output_name"></a> [name](#output\_name) | Network ACL name |
| <a name="output_outbound_rules"></a> [outbound\_rules](#output\_outbound\_rules) | Outbound rules applied to the network ACL |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of subnet IDs associated with the network ACL |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to the network ACL |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID where the network ACL is created |

## Example

See [example/](example/) for a complete working example with all features.

