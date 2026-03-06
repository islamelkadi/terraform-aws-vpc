namespace   = "example"
environment = "dev"
name        = "private-subnets"
region      = "us-east-1"

vpc_id         = "vpc-0a1b2c3d4e5f67890"
subnet_ids     = ["subnet-0a1b2c3d4e5f00001", "subnet-0a1b2c3d4e5f00002"]
vpc_cidr_block = "10.0.0.0/16"

enable_default_deny = true

tags = {
  Purpose = "Example"
}
