region = "us-east-1"

namespace   = "example-org"
environment = "dev"
name        = "vpc-endpoints"

vpc_id             = "vpc-0a1b2c3d4e5f67890"
private_subnet_ids = ["subnet-0a1b2c3d4e5f00001", "subnet-0a1b2c3d4e5f00002"]
route_table_ids    = ["rtb-0a1b2c3d4e5f00001", "rtb-0a1b2c3d4e5f00002"]

enable_s3_endpoint              = true
enable_dynamodb_endpoint        = true
enable_secrets_manager_endpoint = true
enable_ssm_endpoint             = true
enable_bedrock_runtime_endpoint = true
enable_logs_endpoint            = true

enable_bedrock_endpoint               = false
enable_bedrock_agent_endpoint         = false
enable_bedrock_agent_runtime_endpoint = false
enable_step_functions_endpoint        = false

enable_private_dns = true

tags = {
  Example = "vpc-endpoints-basic"
}
