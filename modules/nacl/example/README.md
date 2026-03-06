# Basic Network ACL Example

This example creates a Network ACL that allows VPC internal traffic and denies everything else.

## Usage

```bash
terraform init
terraform plan -var-file=params/input.tfvars
terraform apply -var-file=params/input.tfvars
```

## What This Example Creates

- 1 Network ACL with inbound/outbound rules allowing all traffic within the VPC CIDR
- Default deny-all rules for external traffic

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `vpc_id` | VPC ID where the NACL will be created | `vpc-0a1b2c3d4e5f67890` |
| `subnet_ids` | Subnet IDs to associate with the NACL | 2 fictitious subnets |
| `vpc_cidr_block` | CIDR block allowed in rules | `10.0.0.0/16` |
| `enable_default_deny` | Add deny-all rules | `true` |

## Clean Up

```bash
terraform destroy -var-file=params/input.tfvars
```
