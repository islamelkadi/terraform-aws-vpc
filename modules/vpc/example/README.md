# Basic VPC Example

This example demonstrates the simplest VPC setup using automatic AZ discovery and subnet CIDR generation.

## Features

- VPC with 10.0.0.0/16 CIDR block
- **Automatic AZ selection** - queries region and selects 2 AZs
- **Auto-generated subnet CIDRs** - no need to manually calculate subnets
- Single NAT Gateway for cost optimization
- VPC Flow Logs with 7-day retention

## What Gets Created

The module will automatically:
1. Query available AZs in your AWS region
2. Select the first 2 available AZs
3. Generate subnet CIDRs:
   - Public: 10.0.0.0/24, 10.0.1.0/24
   - Private: 10.0.10.0/24, 10.0.11.0/24
   - Database: 10.0.20.0/24, 10.0.21.0/24

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Clean Up

```bash
terraform destroy
```

## Estimated Monthly Cost

- NAT Gateway: ~$32/month (single NAT)
- Elastic IP: ~$3.60/month
- VPC Flow Logs: ~$0.50/month (minimal traffic)
- **Total: ~$36/month**

Note: Using `single_nat_gateway = true` saves ~$32/month compared to per-AZ NAT Gateways.
