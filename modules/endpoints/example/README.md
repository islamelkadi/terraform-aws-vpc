# Basic VPC Endpoints Example

This example creates VPC endpoints using fictitious VPC, subnet, and route table IDs. Replace them with real values for actual deployment.

## Usage

```bash
terraform init
terraform plan -var-file=params/input.tfvars
terraform apply -var-file=params/input.tfvars
```

## What This Example Creates

- S3 and DynamoDB gateway endpoints (free)
- Secrets Manager, SSM, Bedrock Runtime, and CloudWatch Logs interface endpoints
- Automatic security group for interface endpoints

## Clean Up

```bash
terraform destroy -var-file=params/input.tfvars
```
