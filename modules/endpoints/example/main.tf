# Basic VPC Endpoints Example

module "vpc_endpoints" {
  source = "../"

  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  region      = var.region
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
