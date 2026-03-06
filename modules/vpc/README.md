# Terraform AWS VPC Module

Production-ready AWS VPC module with comprehensive security controls, multi-AZ high availability, and flexible subnet configuration. Supports public, private, and database subnet tiers with optional NAT Gateway and VPC Flow Logs.

## Table of Contents

- [Security Controls](#security-controls)
- [Features](#features)
- [Usage Examples](#usage-examples)
- [Requirements](#requirements)
- [Examples](#examples)

## Security Controls

This module implements security controls based on the metadata module's security policy. Controls can be selectively overridden with documented business justification.

### Available Security Control Overrides

| Override Flag | Control | Default | Common Use Case |
|--------------|---------|---------|-----------------|
| `disable_flow_logs_requirement` | VPC Flow Logs | `false` | Development/test VPCs where CloudTrail provides sufficient audit |
| `disable_private_subnets_requirement` | Private Subnets | `false` | Public-only architectures (static websites, CDN origins) |
| `disable_nat_gateway_requirement` | NAT Gateway | `false` | Cost optimization in dev environments or VPCs without private resources |

### Security Control Architecture

**Two-Layer Design:**
1. **Metadata Module** (Policy Layer): Defines security requirements based on environment
2. **VPC Module** (Enforcement Layer): Validates configuration against policy

**Override Pattern:**
```hcl
security_control_overrides = {
  disable_flow_logs_requirement = true
  justification = "Development VPC, CloudTrail provides sufficient audit trail"
}
```

### Best Practices

1. **Production Environments**: Never override security controls without documented approval
2. **Development Environments**: Overrides acceptable for cost optimization with justification
3. **Audit Trail**: All overrides require `justification` field for compliance
4. **Review Cycle**: Quarterly review of all active overrides

## Features

- **Multi-AZ High Availability**: Automatic subnet distribution across availability zones
- **Three-Tier Subnet Architecture**: Public, private, and database subnet tiers
- **VPC Flow Logs**: Optional CloudWatch Logs integration for network monitoring
- **NAT Gateway**: Optional NAT Gateway for private subnet internet access
- **Flexible Configuration**: Support for single or multiple NAT Gateways
- **DNS Support**: Configurable DNS hostnames and resolution
- **Security by Default**: Flow logs and private subnets enabled by default
- **Consistent Naming**: Integration with metadata module for standardized resource naming

## Usage Examples

### Example 1: Basic VPC with Security Controls

```hcl
module "metadata" {
  source = "github.com/islamelkadi/terraform-aws-metadata"
  
  namespace   = "example"
  environment = "prod"
  name        = "corporate-actions"
  region      = "us-east-1"
}

module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc"
  
  namespace   = module.metadata.namespace
  environment = module.metadata.environment
  name        = "main"
  region      = module.metadata.region
  
  cidr_block = "10.0.0.0/16"
  az_count   = 2
  
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
  database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
  
  enable_nat_gateway = true
  enable_flow_logs   = true
  
  security_controls = module.metadata.security_controls
  
  tags = module.metadata.tags
}
```

### Example 2: Production VPC with High Availability

```hcl
module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  cidr_block = "10.0.0.0/16"
  az_count   = 3  # Three AZs for maximum availability
  
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  
  # High availability NAT Gateway (one per AZ)
  enable_nat_gateway  = true
  single_nat_gateway  = false
  
  # Enhanced monitoring
  enable_flow_logs          = true
  flow_logs_retention_days  = 90
  
  security_controls = module.metadata.security_controls
  
  tags = merge(
    module.metadata.tags,
    {
      Tier = "Network"
      Compliance = "FCAC"
    }
  )
}
```

### Example 3: Development VPC with Cost Optimization

```hcl
module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc"
  
  namespace   = "example"
  environment = "dev"
  name        = "development"
  region      = "us-east-1"
  
  cidr_block = "10.1.0.0/16"
  az_count   = 2
  
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
  
  # Cost optimization: single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  
  # Reduced flow logs retention
  enable_flow_logs         = true
  flow_logs_retention_days = 7
  
  security_controls = module.metadata.security_controls
  
  # Override with justification
  security_control_overrides = {
    disable_nat_gateway_requirement = false
    justification = "Development environment with cost constraints, single NAT acceptable"
  }
  
  tags = module.metadata.tags
}
```

### Example 4: Public-Only VPC with Overrides

```hcl
module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc"
  
  namespace   = "example"
  environment = "dev"
  name        = "public-web"
  region      = "us-east-1"
  
  cidr_block = "10.2.0.0/16"
  az_count   = 2
  
  # Only public subnets for static website hosting
  public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
  
  # No NAT Gateway needed for public-only architecture
  enable_nat_gateway = false
  enable_flow_logs   = true
  
  security_controls = module.metadata.security_controls
  
  # Document why private subnets and NAT Gateway are not needed
  security_control_overrides = {
    disable_private_subnets_requirement = true
    disable_nat_gateway_requirement     = true
    justification = "Static website hosting on S3/CloudFront, no private resources required"
  }
  
  tags = module.metadata.tags
}
```

## Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles){:target="_blank"} module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| VPC Flow Logs | Optional | Required | Required |
| Private subnets | Recommended | Required | Required |
| NAT Gateway HA | Single AZ | Multi-AZ | Multi-AZ |
| Security groups | Enforced | Enforced | Enforced |

For full details on security profiles and how controls vary by environment, see the <a href="https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles" target="_blank">Security Profiles</a> documentation.

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
module "vpc" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  cidr_block = var.cidr_block
  az_count   = var.az_count

  # Subnet CIDRs will be auto-generated:
  # Public: 10.0.0.0/24, 10.0.1.0/24
  # Private: 10.0.10.0/24, 10.0.11.0/24
  # Database: 10.0.20.0/24, 10.0.21.0/24

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_flow_logs         = var.enable_flow_logs
  flow_logs_retention_days = var.flow_logs_retention_days

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
| <a name="module_flow_logs_log_group"></a> [flow\_logs\_log\_group](#module\_flow\_logs\_log\_group) | ../../../terraform-aws-cloudwatch/modules/logs | n/a |
| <a name="module_metadata"></a> [metadata](#module\_metadata) | github.com/islamelkadi/terraform-aws-metadata | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.database_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_iam_policy_document.flow_logs_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for subnet creation. If not specified, will auto-select based on az\_count | `list(string)` | `null` | no |
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Number of availability zones to use (only used if availability\_zones is not specified) | `number` | `2` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#input\_database\_subnet\_cidrs) | CIDR blocks for database subnets | `list(string)` | `[]` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Enable VPC Flow Logs | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_flow_logs_retention_days"></a> [flow\_logs\_retention\_days](#input\_flow\_logs\_retention\_days) | Number of days to retain VPC Flow Logs | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all resources as prefix | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR blocks for private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for public subnets | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_security_control_overrides"></a> [security\_control\_overrides](#input\_security\_control\_overrides) | Override specific security controls with documented justification | <pre>object({<br/>    disable_flow_logs_requirement       = optional(bool, false)<br/>    disable_private_subnets_requirement = optional(bool, false)<br/>    disable_nat_gateway_requirement     = optional(bool, false)<br/>    justification                       = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "disable_flow_logs_requirement": false,<br/>  "disable_nat_gateway_requirement": false,<br/>  "disable_private_subnets_requirement": false,<br/>  "justification": ""<br/>}</pre> | no |
| <a name="input_security_controls"></a> [security\_controls](#input\_security\_controls) | Security controls configuration from metadata module | <pre>object({<br/>    encryption = object({<br/>      require_kms_customer_managed  = bool<br/>      require_encryption_at_rest    = bool<br/>      require_encryption_in_transit = bool<br/>      enable_kms_key_rotation       = bool<br/>    })<br/>    logging = object({<br/>      require_cloudwatch_logs = bool<br/>      min_log_retention_days  = number<br/>      require_access_logging  = bool<br/>      require_flow_logs       = bool<br/>    })<br/>    monitoring = object({<br/>      enable_xray_tracing         = bool<br/>      enable_enhanced_monitoring  = bool<br/>      enable_performance_insights = bool<br/>      require_cloudtrail          = bool<br/>    })<br/>    network = object({<br/>      require_private_subnets = bool<br/>      require_vpc_endpoints   = bool<br/>      block_public_ingress    = bool<br/>      require_imdsv2          = bool<br/>    })<br/>    compliance = object({<br/>      enable_point_in_time_recovery = bool<br/>      require_reserved_concurrency  = bool<br/>      enable_deletion_protection    = bool<br/>    })<br/>    high_availability = object({<br/>      require_multi_az    = bool<br/>      require_nat_gateway = bool<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use a single NAT Gateway for all private subnets (cost optimization) | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones used |
| <a name="output_database_route_table_ids"></a> [database\_route\_table\_ids](#output\_database\_route\_table\_ids) | List of IDs of database route tables |
| <a name="output_database_subnet_arns"></a> [database\_subnet\_arns](#output\_database\_subnet\_arns) | List of ARNs of database subnets |
| <a name="output_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#output\_database\_subnet\_cidrs) | List of CIDR blocks of database subnets |
| <a name="output_database_subnet_group_id"></a> [database\_subnet\_group\_id](#output\_database\_subnet\_group\_id) | ID of database subnet group |
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database\_subnet\_group\_name) | Name of database subnet group |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | List of IDs of database subnets |
| <a name="output_flow_logs_id"></a> [flow\_logs\_id](#output\_flow\_logs\_id) | The ID of the VPC Flow Log |
| <a name="output_flow_logs_log_group_arn"></a> [flow\_logs\_log\_group\_arn](#output\_flow\_logs\_log\_group\_arn) | The ARN of the CloudWatch Log Group for VPC Flow Logs |
| <a name="output_flow_logs_log_group_name"></a> [flow\_logs\_log\_group\_name](#output\_flow\_logs\_log\_group\_name) | The name of the CloudWatch Log Group for VPC Flow Logs |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | The ARN of the Internet Gateway |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of public Elastic IPs created for NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | List of CIDR blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | List of CIDR blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

## Example

See [example/](example/) for a complete working example with all features.

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.
<!-- END_TF_DOCS -->

## Examples

See [example/](example/) for a complete working example.

