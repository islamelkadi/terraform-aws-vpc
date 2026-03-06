# High Availability NAT Gateway Example

This example demonstrates a production-ready NAT Gateway setup with high availability across multiple availability zones.

## Features

- Multiple NAT Gateways (one per AZ)
- Fault tolerance - if one AZ fails, others continue operating
- Each private subnet routes through NAT Gateway in same AZ
- Internet Gateway shared across all AZs
- Production-ready architecture

## Usage

```bash
# Initialize Terraform
terraform init

# Review the plan (default: 2 AZs)
terraform plan

# Apply with 3 AZs
terraform apply -var="az_count=3"

# Clean up
terraform destroy
```

## Architecture

```
VPC (10.0.0.0/16)
├── AZ 1 (ca-central-1a)
│   ├── Public Subnet (10.0.1.0/24)
│   │   └── NAT Gateway 1 + EIP 1
│   └── Private Subnet (10.0.10.0/24)
│       └── Routes through NAT Gateway 1
│
├── AZ 2 (ca-central-1b)
│   ├── Public Subnet (10.0.2.0/24)
│   │   └── NAT Gateway 2 + EIP 2
│   └── Private Subnet (10.0.11.0/24)
│       └── Routes through NAT Gateway 2
│
└── Internet Gateway (shared)
```

## High Availability Benefits

1. **Fault Tolerance**: If one AZ fails, resources in other AZs continue to have internet access
2. **Performance**: Each AZ uses its own NAT Gateway, reducing cross-AZ data transfer
3. **Compliance**: Meets production requirements for availability

## Cost Estimate (2 AZs)

- NAT Gateway: ~$32/month × 2 = $64/month
- Elastic IPs: ~$3.60/month × 2 = $7.20/month (when not attached)
- Data transfer: Variable based on usage

Total: ~$71/month + data transfer costs

## Cost Estimate (3 AZs)

- NAT Gateway: ~$32/month × 3 = $96/month
- Elastic IPs: ~$3.60/month × 3 = $10.80/month (when not attached)
- Data transfer: Variable based on usage

Total: ~$107/month + data transfer costs

## Cost Optimization Tips

1. Use VPC endpoints for AWS services (S3, DynamoDB) to avoid NAT Gateway data transfer
2. Consider single NAT Gateway for non-production environments
3. Monitor data transfer costs with CloudWatch

## Notes

- This is the recommended setup for production workloads
- Each private subnet routes through the NAT Gateway in its own AZ
- If cost is a concern for development, use the basic example instead
