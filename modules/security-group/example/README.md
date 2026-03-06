# Basic Security Group Example

This example demonstrates a simple security group configuration for Lambda functions with HTTPS egress to VPC endpoints.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## What This Example Creates

- 1 Security group with HTTPS egress scoped to the VPC CIDR block

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `vpc_id` | VPC ID where the security group will be created | `vpc-0a1b2c3d4e5f67890` |
| `vpc_cidr_block` | CIDR block of the VPC | `10.0.0.0/16` |
| `description` | Description of the security group | `Security group for Lambda functions` |

## Clean Up

```bash
terraform destroy
```
