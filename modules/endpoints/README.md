# Terraform AWS VPC Endpoints Module

Production-ready AWS VPC Endpoints module for private connectivity to AWS services. Supports both Gateway endpoints (S3, DynamoDB) and Interface endpoints (Bedrock, Lambda, Secrets Manager, etc.) with automatic security group management.

## Table of Contents

- [Features](#features)
- [Usage Example](#usage-example)
- [Requirements](#requirements)

## Features

- **Gateway Endpoints**: S3 and DynamoDB (no data transfer costs)
- **Interface Endpoints**: Bedrock, Bedrock Runtime, Bedrock Agent, CloudWatch Logs, Secrets Manager, SSM, Step Functions
- **Private DNS**: Automatic private DNS configuration for interface endpoints
- **Security Group Management**: Automatic security group creation or use existing
- **Cost Optimization**: Selective endpoint enablement
- **Consistent Naming**: Integration with metadata module for standardized resource naming

## Security

### Environment-Based Security Controls

Security controls are automatically applied based on the environment through the [terraform-aws-metadata](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) module's security profiles:

| Control | Dev | Staging | Prod |
|---------|-----|---------|------|
| VPC Endpoints | Optional | Recommended | Required |
| Private DNS | Enabled | Enabled | Enabled |
| Security group restrictions | Enforced | Enforced | Enforced |

For full details on security profiles and how controls vary by environment, see the [Security Profiles](https://github.com/islamelkadi/terraform-aws-metadata?tab=readme-ov-file#security-profiles) documentation.

## Usage Example

```hcl
module "vpc_endpoints" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/endpoints"
  
  namespace   = "example"
  environment = "prod"
  name        = "corporate-actions"
  region      = "us-east-1"
  
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  route_table_ids    = module.vpc.private_route_table_ids
  
  # Enable required endpoints
  enable_s3_endpoint                      = true
  enable_dynamodb_endpoint                = true
  enable_bedrock_runtime_endpoint         = true
  enable_bedrock_agent_runtime_endpoint   = true
  enable_secrets_manager_endpoint         = true
  enable_logs_endpoint                    = true
  enable_step_functions_endpoint          = true
  
  enable_private_dns = true
  
  allowed_cidr_blocks = [module.vpc.cidr_block]
  
  tags = {
    Tier = "Network"
  }
}
```

<!-- BEGIN_TF_DOCS -->

## Usage

```hcl
# Basic VPC Endpoints Example

module "vpc_endpoints" {
  source = "github.com/islamelkadi/terraform-aws-vpc//modules/endpoints"

  region             = var.region
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  route_table_ids    = var.route_table_ids

  enable_s3_endpoint              = var.enable_s3_endpoint
  enable_dynamodb_endpoint        = var.enable_dynamodb_endpoint
  enable_secrets_manager_endpoint = var.enable_secrets_manager_endpoint
  enable_ssm_endpoint             = var.enable_ssm_endpoint
  enable_bedrock_runtime_endpoint = var.enable_bedrock_runtime_endpoint
  enable_logs_endpoint            = var.enable_logs_endpoint

  enable_bedrock_endpoint               = var.enable_bedrock_endpoint
  enable_bedrock_agent_endpoint         = var.enable_bedrock_agent_endpoint
  enable_bedrock_agent_runtime_endpoint = var.enable_bedrock_agent_runtime_endpoint
  enable_step_functions_endpoint        = var.enable_step_functions_endpoint

  enable_private_dns = var.enable_private_dns

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
| [aws_security_group.endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.bedrock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.bedrock_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.bedrock_agent_runtime](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.bedrock_runtime](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to access interface endpoints (used if security\_group\_ids is empty) | `list(string)` | `[]` | no |
| <a name="input_enable_bedrock_agent_endpoint"></a> [enable\_bedrock\_agent\_endpoint](#input\_enable\_bedrock\_agent\_endpoint) | Enable Bedrock Agent interface endpoint | `bool` | `true` | no |
| <a name="input_enable_bedrock_agent_runtime_endpoint"></a> [enable\_bedrock\_agent\_runtime\_endpoint](#input\_enable\_bedrock\_agent\_runtime\_endpoint) | Enable Bedrock Agent Runtime interface endpoint | `bool` | `true` | no |
| <a name="input_enable_bedrock_endpoint"></a> [enable\_bedrock\_endpoint](#input\_enable\_bedrock\_endpoint) | Enable Bedrock interface endpoint | `bool` | `true` | no |
| <a name="input_enable_bedrock_runtime_endpoint"></a> [enable\_bedrock\_runtime\_endpoint](#input\_enable\_bedrock\_runtime\_endpoint) | Enable Bedrock Runtime interface endpoint | `bool` | `true` | no |
| <a name="input_enable_dynamodb_endpoint"></a> [enable\_dynamodb\_endpoint](#input\_enable\_dynamodb\_endpoint) | Enable DynamoDB Gateway endpoint (no data transfer costs) | `bool` | `true` | no |
| <a name="input_enable_logs_endpoint"></a> [enable\_logs\_endpoint](#input\_enable\_logs\_endpoint) | Enable CloudWatch Logs interface endpoint | `bool` | `true` | no |
| <a name="input_enable_private_dns"></a> [enable\_private\_dns](#input\_enable\_private\_dns) | Enable private DNS for interface endpoints | `bool` | `true` | no |
| <a name="input_enable_s3_endpoint"></a> [enable\_s3\_endpoint](#input\_enable\_s3\_endpoint) | Enable S3 Gateway endpoint (no data transfer costs) | `bool` | `true` | no |
| <a name="input_enable_secrets_manager_endpoint"></a> [enable\_secrets\_manager\_endpoint](#input\_enable\_secrets\_manager\_endpoint) | Enable Secrets Manager interface endpoint | `bool` | `true` | no |
| <a name="input_enable_ssm_endpoint"></a> [enable\_ssm\_endpoint](#input\_enable\_ssm\_endpoint) | Enable SSM Parameter Store interface endpoint | `bool` | `true` | no |
| <a name="input_enable_step_functions_endpoint"></a> [enable\_step\_functions\_endpoint](#input\_enable\_step\_functions\_endpoint) | Enable Step Functions interface endpoint | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the VPC endpoints module | `string` | `"vpc-endpoints"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resource naming (e.g., organization name) | `string` | `""` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs for interface endpoints | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route table IDs for gateway endpoints | `list(string)` | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for interface endpoints. If not provided, a default security group will be created | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where endpoints will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bedrock_agent_endpoint_dns_entries"></a> [bedrock\_agent\_endpoint\_dns\_entries](#output\_bedrock\_agent\_endpoint\_dns\_entries) | DNS entries for the Bedrock Agent interface endpoint |
| <a name="output_bedrock_agent_endpoint_id"></a> [bedrock\_agent\_endpoint\_id](#output\_bedrock\_agent\_endpoint\_id) | ID of the Bedrock Agent interface endpoint |
| <a name="output_bedrock_agent_runtime_endpoint_dns_entries"></a> [bedrock\_agent\_runtime\_endpoint\_dns\_entries](#output\_bedrock\_agent\_runtime\_endpoint\_dns\_entries) | DNS entries for the Bedrock Agent Runtime interface endpoint |
| <a name="output_bedrock_agent_runtime_endpoint_id"></a> [bedrock\_agent\_runtime\_endpoint\_id](#output\_bedrock\_agent\_runtime\_endpoint\_id) | ID of the Bedrock Agent Runtime interface endpoint |
| <a name="output_bedrock_endpoint_dns_entries"></a> [bedrock\_endpoint\_dns\_entries](#output\_bedrock\_endpoint\_dns\_entries) | DNS entries for the Bedrock interface endpoint |
| <a name="output_bedrock_endpoint_id"></a> [bedrock\_endpoint\_id](#output\_bedrock\_endpoint\_id) | ID of the Bedrock interface endpoint |
| <a name="output_bedrock_runtime_endpoint_dns_entries"></a> [bedrock\_runtime\_endpoint\_dns\_entries](#output\_bedrock\_runtime\_endpoint\_dns\_entries) | DNS entries for the Bedrock Runtime interface endpoint |
| <a name="output_bedrock_runtime_endpoint_id"></a> [bedrock\_runtime\_endpoint\_id](#output\_bedrock\_runtime\_endpoint\_id) | ID of the Bedrock Runtime interface endpoint |
| <a name="output_dynamodb_endpoint_id"></a> [dynamodb\_endpoint\_id](#output\_dynamodb\_endpoint\_id) | ID of the DynamoDB Gateway endpoint |
| <a name="output_dynamodb_endpoint_prefix_list_id"></a> [dynamodb\_endpoint\_prefix\_list\_id](#output\_dynamodb\_endpoint\_prefix\_list\_id) | Prefix list ID of the DynamoDB Gateway endpoint |
| <a name="output_gateway_endpoint_ids"></a> [gateway\_endpoint\_ids](#output\_gateway\_endpoint\_ids) | Map of gateway endpoint IDs |
| <a name="output_interface_endpoint_ids"></a> [interface\_endpoint\_ids](#output\_interface\_endpoint\_ids) | Map of interface endpoint IDs |
| <a name="output_logs_endpoint_dns_entries"></a> [logs\_endpoint\_dns\_entries](#output\_logs\_endpoint\_dns\_entries) | DNS entries for the CloudWatch Logs interface endpoint |
| <a name="output_logs_endpoint_id"></a> [logs\_endpoint\_id](#output\_logs\_endpoint\_id) | ID of the CloudWatch Logs interface endpoint |
| <a name="output_s3_endpoint_id"></a> [s3\_endpoint\_id](#output\_s3\_endpoint\_id) | ID of the S3 Gateway endpoint |
| <a name="output_s3_endpoint_prefix_list_id"></a> [s3\_endpoint\_prefix\_list\_id](#output\_s3\_endpoint\_prefix\_list\_id) | Prefix list ID of the S3 Gateway endpoint |
| <a name="output_secrets_manager_endpoint_dns_entries"></a> [secrets\_manager\_endpoint\_dns\_entries](#output\_secrets\_manager\_endpoint\_dns\_entries) | DNS entries for the Secrets Manager interface endpoint |
| <a name="output_secrets_manager_endpoint_id"></a> [secrets\_manager\_endpoint\_id](#output\_secrets\_manager\_endpoint\_id) | ID of the Secrets Manager interface endpoint |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group created for interface endpoints |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group created for interface endpoints |
| <a name="output_ssm_endpoint_dns_entries"></a> [ssm\_endpoint\_dns\_entries](#output\_ssm\_endpoint\_dns\_entries) | DNS entries for the SSM Parameter Store interface endpoint |
| <a name="output_ssm_endpoint_id"></a> [ssm\_endpoint\_id](#output\_ssm\_endpoint\_id) | ID of the SSM Parameter Store interface endpoint |
| <a name="output_step_functions_endpoint_dns_entries"></a> [step\_functions\_endpoint\_dns\_entries](#output\_step\_functions\_endpoint\_dns\_entries) | DNS entries for the Step Functions interface endpoint |
| <a name="output_step_functions_endpoint_id"></a> [step\_functions\_endpoint\_id](#output\_step\_functions\_endpoint\_id) | ID of the Step Functions interface endpoint |

## Example

See [example/](example/) for a complete working example with all features.

