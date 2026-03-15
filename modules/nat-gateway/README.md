# Terraform AWS NAT Gateway Module

Production-ready AWS NAT Gateway module with Internet Gateway integration, Elastic IP management, and high availability support. Enables private subnet resources to access the internet while remaining protected from inbound connections.

## Table of Contents

- [Security](#security)
- [Features](#features)
- [Usage Examples](#usage-examples)
- [Requirements](#requirements)
- [Examples](#examples)

## Features

- **High Availability**: Support for multiple NAT Gateways across availability zones
- **Elastic IP Management**: Automatic Elastic IP allocation and association
- **Internet Gateway Integration**: Optional Internet Gateway creation or use existing
- **Flexible Deployment**: Single or multi-AZ NAT Gateway configurations
- **Public/Private Connectivity**: Support for both public and private NAT Gateways
- **Consistent Naming**: Integration with metadata module for standardized resource naming
- **Cost Optimization**: Configurable single NAT Gateway for development environments

## Security

### Security Controls

This module implements security controls based on the metadata module's security policy. Controls can be selectively overridden with documented business justification.

### Available Security Control Overrides

| Override Flag | Control | Default | Common Use Case |
|--------------|---------|---------|-----------------|
| `disable_high_availability` | Multi-AZ NAT Gateway | `false` | Development environments with cost constraints |

### Security Control Architecture

**Two-Layer Design:**
1. **Metadata Module** (Policy Layer): Defines security requirements based on environment
2. **NAT Gateway Module** (Enforcement Layer): Validates configuration against policy

**Override Pattern:**
```hcl
security_control_overrides = {
  disable_high_availability = true
  justification = "Development environment, single NAT Gateway acceptable for cost optimization"
}
```

### Best Practices

1. **Production Environments**: Deploy one NAT Gateway per AZ for high availability
2. **Development Environments**: Single NAT Gateway acceptable with documented justification
3. **Cost Optimization**: Use single NAT Gateway in dev, multiple in prod
4. **Audit Trail**: All overrides require `justification` field for compliance

### Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| NAT Gateway HA | Single AZ | Multi-AZ | Multi-AZ |
| Internet Gateway | Required | Required | Required |
| Elastic IP management | Automatic | Automatic | Automatic |

For full details on security profiles and how controls vary by environment, see the [Security Profiles](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) documentation.
## Usage Examples

### Example 1: Basic NAT Gateway with Security Controls

```hcl
module "metadata" {
  source = "github.com/islamelkadi/terraform-aws-metadata"
  
  namespace   = "example"
  environment = "prod"
  name        = "corporate-actions"
  region      = "us-east-1"
}

module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway"
  
  namespace   = module.metadata.namespace
  environment = module.metadata.environment
  name        = "main"
  region      = module.metadata.region
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  
  enable_nat_gateway        = true
  create_internet_gateway   = true
  
  security_controls = module.metadata.security_controls
  
  tags = module.metadata.tags
}
```

### Example 2: Production High Availability NAT Gateway

```hcl
module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id = module.vpc.vpc_id
  
  # One NAT Gateway per AZ for high availability
  public_subnet_ids = [
    module.vpc.public_subnet_ids[0],
    module.vpc.public_subnet_ids[1],
    module.vpc.public_subnet_ids[2]
  ]
  
  enable_nat_gateway      = true
  create_internet_gateway = true
  connectivity_type       = "public"
  
  security_controls = module.metadata.security_controls
  
  tags = merge(
    module.metadata.tags,
    {
      Tier = "Network"
      HighAvailability = "true"
    }
  )
}
```

### Example 3: Development Single NAT Gateway with Override

```hcl
module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway"
  
  namespace   = "example"
  environment = "dev"
  name        = "development"
  region      = "us-east-1"
  
  vpc_id = module.vpc.vpc_id
  
  # Single NAT Gateway for cost optimization
  public_subnet_ids = [module.vpc.public_subnet_ids[0]]
  
  enable_nat_gateway      = true
  create_internet_gateway = true
  
  security_controls = module.metadata.security_controls
  
  # Override high availability requirement with justification
  security_control_overrides = {
    disable_high_availability = true
    justification = "Development environment with cost constraints, single NAT Gateway acceptable"
  }
  
  tags = module.metadata.tags
}
```

### Example 4: Using Existing Internet Gateway

```hcl
module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  
  enable_nat_gateway      = true
  create_internet_gateway = false
  internet_gateway_id     = data.aws_internet_gateway.existing.id
  
  security_controls = module.metadata.security_controls
  
  tags = module.metadata.tags
}
```

<!-- BEGIN_TF_DOCS -->

## Usage

```hcl
# High Availability NAT Gateway Example
# Multiple NAT Gateways across availability zones for production

# VPC module
module "vpc" {
  source = "../../vpc"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

  az_count = var.az_count

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false # We'll use the standalone NAT Gateway module
  enable_flow_logs     = false # Simplified for example

  tags = var.tags
}

# NAT Gateway module (creates one NAT Gateway per public subnet)
module "nat_gateway" {
  source = "./.."

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  tags = var.tags
}

# Update private route tables to use NAT Gateways
# Each private subnet uses NAT Gateway in same AZ
resource "aws_route" "private_nat_gateway" {
  count = var.az_count

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_ids[count.index]
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
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes for naming | `list(string)` | `[]` | no |
| <a name="input_connectivity_type"></a> [connectivity\_type](#input\_connectivity\_type) | Connectivity type for NAT Gateway (public or private) | `string` | `"public"` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Create an Internet Gateway for the VPC (required for public NAT Gateway) | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to use between name components | `string` | `"-"` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable NAT Gateway creation | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_internet_gateway_id"></a> [internet\_gateway\_id](#input\_internet\_gateway\_id) | Existing Internet Gateway ID (if create\_internet\_gateway is false) | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the NAT Gateway | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (organization/team name) | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs where NAT Gateways will be created (one per AZ for HA) | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_security_control_overrides"></a> [security\_control\_overrides](#input\_security\_control\_overrides) | Override specific security controls for this NAT Gateway.<br/>Only use when there's a documented business justification.<br/><br/>Example use cases:<br/>- disable\_high\_availability: Development environments with cost constraints<br/><br/>IMPORTANT: Document the reason in the 'justification' field for audit purposes. | <pre>object({<br/>    disable_high_availability = optional(bool, false)<br/><br/>    # Audit trail - document why controls are disabled<br/>    justification = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "disable_high_availability": false,<br/>  "justification": ""<br/>}</pre> | no |
| <a name="input_security_controls"></a> [security\_controls](#input\_security\_controls) | Security controls configuration from metadata module | <pre>object({<br/>    encryption = object({<br/>      require_kms_customer_managed  = bool<br/>      require_encryption_at_rest    = bool<br/>      require_encryption_in_transit = bool<br/>      enable_kms_key_rotation       = bool<br/>    })<br/>    logging = object({<br/>      require_cloudwatch_logs = bool<br/>      min_log_retention_days  = number<br/>      require_access_logging  = bool<br/>      require_flow_logs       = bool<br/>    })<br/>    monitoring = object({<br/>      enable_xray_tracing         = bool<br/>      enable_enhanced_monitoring  = bool<br/>      enable_performance_insights = bool<br/>      require_cloudtrail          = bool<br/>    })<br/>    network = object({<br/>      require_private_subnets = bool<br/>      require_vpc_endpoints   = bool<br/>      block_public_ingress    = bool<br/>      require_imdsv2          = bool<br/>    })<br/>    compliance = object({<br/>      enable_point_in_time_recovery = bool<br/>      require_reserved_concurrency  = bool<br/>      enable_deletion_protection    = bool<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where NAT Gateway will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones where NAT Gateways are deployed |
| <a name="output_elastic_ip_ids"></a> [elastic\_ip\_ids](#output\_elastic\_ip\_ids) | List of Elastic IP allocation IDs |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | ARN of the Internet Gateway |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs |
| <a name="output_nat_gateway_network_interface_ids"></a> [nat\_gateway\_network\_interface\_ids](#output\_nat\_gateway\_network\_interface\_ids) | List of ENI IDs associated with NAT Gateways |
| <a name="output_nat_gateway_private_ips"></a> [nat\_gateway\_private\_ips](#output\_nat\_gateway\_private\_ips) | List of private IPs associated with NAT Gateways |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | List of public Elastic IPs associated with NAT Gateways |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to NAT Gateway resources |

## Examples

See [example/](example/) for a complete working example.

<!-- END_TF_DOCS -->