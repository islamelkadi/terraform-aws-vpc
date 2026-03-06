# Terraform AWS Security Group Module

Production-ready AWS Security Group module for instance-level network filtering. Provides stateful firewall rules with automatic return traffic handling and public ingress protection.

## Table of Contents

- [Features](#features)
- [Usage Example](#usage-example)
- [Requirements](#requirements)

## Features

- **Ingress/Egress Rules**: Separate rule management for inbound and outbound traffic
- **Public Ingress Protection**: Blocks 0.0.0.0/0 by default (explicit override required)
- **Security Group References**: Support for security group-to-security group rules
- **Prefix Lists**: Support for AWS-managed prefix lists
- **Rule Descriptions**: Required descriptions for audit and documentation
- **Consistent Naming**: Integration with metadata module for standardized resource naming

## Usage Example

```hcl
module "lambda_sg" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/security-group"
  
  namespace   = "example"
  environment = "prod"
  name        = "lambda-functions"
  region      = "us-east-1"
  
  vpc_id      = module.vpc.vpc_id
  description = "Security group for Lambda functions"
  
  egress_rules = [
    {
      description = "HTTPS to VPC endpoints"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [module.vpc.cidr_block]
    },
    {
      description = "PostgreSQL to RDS"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      source_security_group_id = module.rds_sg.id
    }
  ]
  
  tags = {
    Tier = "Compute"
  }
}
```

## Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles){:target="_blank"} module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| Block public ingress (0.0.0.0/0) | Enforced | Enforced | Enforced |
| Rule descriptions | Recommended | Required | Required |
| Restrictive egress | Recommended | Required | Required |

For full details on security profiles and how controls vary by environment, see the <a href="https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles" target="_blank">Security Profiles</a> documentation.

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
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
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_ingress"></a> [allow\_public\_ingress](#input\_allow\_public\_ingress) | Explicitly allow ingress rules with 0.0.0.0/0 or ::/0. Set to true only when public access is required | `bool` | `false` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes for naming | `list(string)` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to use between name components | `string` | `"-"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | n/a | yes |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules. Each rule must have a description | <pre>list(object({<br/>    description              = string<br/>    from_port                = number<br/>    to_port                  = number<br/>    protocol                 = string<br/>    cidr_blocks              = optional(list(string))<br/>    ipv6_cidr_blocks         = optional(list(string))<br/>    source_security_group_id = optional(string)<br/>    prefix_list_ids          = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules. Each rule must have a description and cannot use 0.0.0.0/0 by default (set allow\_public\_ingress=true to override) | <pre>list(object({<br/>    description              = string<br/>    from_port                = number<br/>    to_port                  = number<br/>    protocol                 = string<br/>    cidr_blocks              = optional(list(string))<br/>    ipv6_cidr_blocks         = optional(list(string))<br/>    source_security_group_id = optional(string)<br/>    prefix_list_ids          = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the security group | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the security group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Security group ARN |
| <a name="output_egress_rules"></a> [egress\_rules](#output\_egress\_rules) | Egress rules applied to the security group |
| <a name="output_id"></a> [id](#output\_id) | Security group ID |
| <a name="output_ingress_rules"></a> [ingress\_rules](#output\_ingress\_rules) | Ingress rules applied to the security group |
| <a name="output_name"></a> [name](#output\_name) | Security group name |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to the security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID where the security group is created |

## Example

See [example/](example/) for a complete working example with all features.

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.
<!-- END_TF_DOCS -->


