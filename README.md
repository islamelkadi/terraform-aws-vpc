# Terraform AWS VPC Module

A comprehensive Terraform module for AWS networking infrastructure including VPC, VPC Endpoints, Network ACLs, and Security Groups.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Security](#security)
- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [MCP Servers](#mcp-servers)

## Prerequisites

This module is designed for macOS. The following must already be installed on your machine:
- Python 3 and pip
- [Kiro](https://kiro.dev) and Kiro CLI
- [Homebrew](https://brew.sh)

To install the remaining development tools, run:

```bash
make bootstrap
```

This will install/upgrade: tfenv, Terraform (via tfenv), tflint, terraform-docs, checkov, and pre-commit.

## Security

### Security Controls

This module implements security controls to comply with:
- AWS Foundational Security Best Practices (FSBP)
- CIS AWS Foundations Benchmark
- NIST 800-53 Rev 5
- NIST 800-171 Rev 2
- PCI DSS v4.0

### Implemented Controls

- [x] **Flow Logs**: Enabled with CloudWatch for network traffic monitoring
- [x] **Private Subnets**: For compute resources isolation
- [x] **NAT Gateway**: High availability option for private subnet internet access
- [x] **Security Groups**: Stateful firewall with least privilege rules
- [x] **Network ACLs**: Optional stateless firewall for defense in depth
- [x] **Security Control Overrides**: Extensible override system with audit justification
- [ ] **VPC Endpoints**: For AWS services (optional, cost vs security tradeoff)

For complete security standards and implementation details, see [AWS Security Standards](../../../.kiro/steering/aws/aws-security-standards.md).

### Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| VPC Flow Logs | Optional | Required | Required |
| Private subnets | Recommended | Required | Required |
| NAT Gateway HA | Single AZ | Multi-AZ | Multi-AZ |
| Security groups | Enforced | Enforced | Enforced |
| Network ACLs | Optional | Recommended | Required |
| VPC Endpoints | Optional | Recommended | Required |

For full details on security profiles and how controls vary by environment, see the [Security Profiles](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) documentation.
## Submodules

This module contains five submodules for complete VPC networking:

### 1. VPC (`modules/vpc`)
Creates AWS VPC with subnets, NAT gateways, internet gateways, and flow logs.

**Features:**
- Public and private subnets across multiple availability zones
- NAT Gateway for private subnet internet access
- Internet Gateway for public subnet access
- VPC Flow Logs to CloudWatch
- Route tables and associations
- Security by default (private subnets, flow logs enabled)

**Usage:**
```hcl
module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["ca-central-1a", "ca-central-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  
  enable_nat_gateway = true
  enable_flow_logs   = true
  
  kms_key_arn = aws_kms_key.main.arn
}
```

### 2. NAT Gateway (`modules/nat-gateway`)
Creates NAT Gateway with Internet Gateway for private subnet internet access.

**Features:**
- NAT Gateway in public subnets
- Automatic Elastic IP allocation
- Internet Gateway creation and management
- High availability support (multiple NAT Gateways across AZs)
- Security controls integration
- Cost optimization options (single vs multi-AZ)

**Usage:**
```hcl
module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id = module.vpc.vpc_id
  
  # Multiple subnets across AZs for HA
  public_subnet_ids = [
    module.vpc.public_subnet_ids[0],  # ca-central-1a
    module.vpc.public_subnet_ids[1],  # ca-central-1b
  ]
  
  tags = {
    Project = "CorporateActions"
  }
}
```

### 3. VPC Endpoints (`modules/endpoints`)
Creates VPC endpoints for AWS services to keep traffic within the VPC.

**Features:**
- Interface endpoints (PrivateLink)
- Gateway endpoints (S3, DynamoDB)
- Security group management
- Private DNS enabled
- Cost-effective gateway endpoints where available

**Usage:**
```hcl
module "vpc_endpoints" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/endpoints?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.id]
  
  # Gateway endpoints (free)
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true
  
  # Interface endpoints (charged)
  enable_lambda_endpoint      = true
  enable_secretsmanager_endpoint = true
  enable_bedrock_endpoint     = true
}
```

### 4. Network ACLs (`modules/nacl`)
Creates Network ACLs for subnet-level security (defense in depth).

**Features:**
- Stateless firewall rules at subnet level
- Ingress and egress rules
- Rule number management
- ICMP, TCP, UDP protocol support
- Complements security groups for defense in depth

**Usage:**
```hcl
module "nacl" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nacl?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "private"
  region      = "us-east-1"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  ingress_rules = [
    {
      rule_number = 100
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/16"
      from_port   = 443
      to_port     = 443
    }
  ]
  
  egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  ]
}
```

### 5. Security Groups (`modules/security-group`)
Creates Security Groups for instance-level security (stateful firewall).

**Features:**
- Stateful firewall rules at instance level
- Ingress and egress rules
- Support for CIDR blocks and source security groups
- Protocol-specific rules (TCP, UDP, ICMP, all)
- Primary security control for EC2, Lambda, RDS, etc.

**Usage:**
```hcl
module "security_group" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/security-group?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "lambda"
  region      = "us-east-1"
  
  vpc_id      = module.vpc.vpc_id
  description = "Security group for Lambda functions"
  
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "HTTPS from VPC"
    }
  ]
  
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}
```

## Complete Example

Here's how to use all five submodules together:

```hcl
# 1. Create VPC with subnets
module "vpc" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/vpc?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ca-central-1a", "ca-central-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  
  enable_nat_gateway = true
  enable_flow_logs   = true
  
  kms_key_arn = aws_kms_key.main.arn
}

# 2. Create NAT Gateway (optional - if not using VPC module's built-in NAT)
module "nat_gateway" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nat-gateway?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id = module.vpc.vpc_id
  
  # Multiple subnets across AZs for HA
  public_subnet_ids = module.vpc.public_subnet_ids
  
  tags = {
    Project = "CorporateActions"
  }
}

# 3. Create Security Groups
module "lambda_sg" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/security-group?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "lambda"
  region      = "us-east-1"
  
  vpc_id      = module.vpc.vpc_id
  description = "Security group for Lambda functions"
  
  egress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS to internet"
    }
  ]
}

# 4. Create VPC Endpoints
module "vpc_endpoints" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/endpoints?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "main"
  region      = "us-east-1"
  
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.lambda_sg.id]
  
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true
  enable_lambda_endpoint   = true
}

# 5. Create Network ACLs
module "private_nacl" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/nacl?ref=v1.0.0"
  
  namespace   = "example"
  environment = "prod"
  name        = "private"
  region      = "us-east-1"
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  ingress_rules = [
    {
      rule_number = 100
      protocol    = "tcp"
      rule_action = "allow"
      cidr_block  = "10.0.0.0/16"
      from_port   = 443
      to_port     = 443
    }
  ]
  
  egress_rules = [
    {
      rule_number = 100
      protocol    = "-1"
      rule_action = "allow"
      cidr_block  = "0.0.0.0/0"
      from_port   = 0
      to_port     = 0
    }
  ]
}
```

## Module Structure

```
terraform-aws-vpc/
├── modules/
│   ├── vpc/                    # VPC with subnets, NAT, IGW
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── data.tf
│   │   ├── metadata.tf
│   │   ├── provider.tf
│   │   ├── security-validations.tf
│   │   ├── example/
│   │   └── README.md
│   ├── nat-gateway/            # NAT Gateway with IGW
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── locals.tf
│   │   ├── security-validations.tf
│   │   ├── versions.tf
│   │   ├── example/
│   │   └── README.md
│   ├── endpoints/              # VPC Endpoints
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── locals.tf
│   │   ├── metadata.tf
│   │   ├── provider.tf
│   │   ├── example/
│   │   └── README.md
│   ├── nacl/                   # Network ACLs
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── locals.tf
│   │   ├── metadata.tf
│   │   ├── provider.tf
│   │   ├── example/
│   │   └── README.md
│   └── security-group/         # Security Groups
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       ├── metadata.tf
│       ├── provider.tf
│       ├── example/
│       └── README.md
└── README.md
```

## Why Five Submodules?

**Separation of Concerns:**
- VPC is the foundation (always needed)
- NAT Gateway provides private subnet internet access (optional, can be managed by VPC module)
- Security Groups are the primary firewall (almost always needed)
- Endpoints are optional (cost vs security tradeoff)
- NACLs are optional (additional security layer for compliance)

**Flexibility:**
- Use only VPC for simple setups
- Add NAT Gateway as standalone for more control over HA and cost
- Add security groups for instance-level security
- Add endpoints for private AWS service access
- Add NACLs for compliance requirements (defense in depth)

**Independent Versioning:**
- Each submodule can evolve independently
- Breaking changes isolated to specific submodule

## Security Features

All submodules implement security best practices:

- **VPC**: Private subnets by default, flow logs enabled, KMS encryption
- **Security Groups**: Stateful firewall, least privilege rules
- **Endpoints**: Private DNS enabled, security group restrictions
- **NACLs**: Stateless firewall rules, explicit allow/deny

## Security Groups vs NACLs

**Security Groups (Stateful):**
- Instance-level security
- Stateful (return traffic automatically allowed)
- Only allow rules (implicit deny)
- Evaluate all rules before deciding
- Primary security control

**Network ACLs (Stateless):**
- Subnet-level security
- Stateless (must explicitly allow return traffic)
- Allow and deny rules
- Process rules in order by rule number
- Defense in depth / compliance requirement

**Best Practice:** Use Security Groups as primary control, add NACLs for additional layer when needed.

## Examples

See each submodule's directory for specific examples:
- [VPC Example](modules/vpc/example/)
- [NAT Gateway Example](modules/nat-gateway/example/)
- [Security Group Example](modules/security-group/example/)
- [Endpoints Example](modules/endpoints/example/)
- [NACL Example](modules/nacl/example/)

## MCP Servers

This module includes two [Model Context Protocol (MCP)](https://modelcontextprotocol.io/) servers configured in `.kiro/settings/mcp.json` for use with Kiro:

| Server | Package | Description |
|--------|---------|-------------|
| `aws-docs` | `awslabs.aws-documentation-mcp-server@latest` | Provides access to AWS documentation for contextual lookups of service features, API references, and best practices. |
| `terraform` | `awslabs.terraform-mcp-server@latest` | Enables Terraform operations (init, validate, plan, fmt, tflint) directly from the IDE with auto-approved commands for common workflows. |

Both servers run via `uvx` and require no additional installation beyond the [bootstrap](#prerequisites) step.

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

