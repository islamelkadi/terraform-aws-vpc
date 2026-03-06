# Security Controls Validations
# Enforces security standards based on metadata module security controls
# Supports selective overrides with documented justification

locals {
  # Use security controls if provided, otherwise use permissive defaults
  security_controls = var.security_controls != null ? var.security_controls : {
    encryption = {
      require_kms_customer_managed  = false
      require_encryption_at_rest    = false
      require_encryption_in_transit = false
      enable_kms_key_rotation       = false
    }
    logging = {
      require_cloudwatch_logs = false
      min_log_retention_days  = 1
      require_access_logging  = false
      require_flow_logs       = false
    }
    monitoring = {
      enable_xray_tracing         = false
      enable_enhanced_monitoring  = false
      enable_performance_insights = false
      require_cloudtrail          = false
    }
    network = {
      require_private_subnets = false
      require_vpc_endpoints   = false
      block_public_ingress    = false
      require_imdsv2          = false
    }
    compliance = {
      enable_point_in_time_recovery = false
      require_reserved_concurrency  = false
      enable_deletion_protection    = false
    }
    high_availability = {
      require_multi_az    = false
      require_nat_gateway = false
    }
  }

  # Apply overrides to security controls
  # Controls are enforced UNLESS explicitly overridden with justification
  flow_logs_required       = local.security_controls.logging.require_flow_logs && !var.security_control_overrides.disable_flow_logs_requirement
  private_subnets_required = local.security_controls.network.require_private_subnets && !var.security_control_overrides.disable_private_subnets_requirement
  nat_gateway_required     = local.security_controls.high_availability.require_nat_gateway && !var.security_control_overrides.disable_nat_gateway_requirement
  kms_encryption_required  = local.security_controls.encryption.require_kms_customer_managed && !var.security_control_overrides.disable_kms_requirement

  # Validation results
  flow_logs_validation_passed       = !local.flow_logs_required || var.enable_flow_logs
  private_subnets_validation_passed = !local.private_subnets_required || length(var.private_subnet_cidrs) > 0
  nat_gateway_validation_passed     = !local.nat_gateway_required || var.enable_nat_gateway
  kms_encryption_validation_passed  = !local.kms_encryption_required || var.kms_key_arn != null

  # Audit trail for overrides
  has_overrides = (
    var.security_control_overrides.disable_flow_logs_requirement ||
    var.security_control_overrides.disable_private_subnets_requirement ||
    var.security_control_overrides.disable_nat_gateway_requirement ||
    var.security_control_overrides.disable_kms_requirement
  )

  justification_provided = var.security_control_overrides.justification != ""
  override_audit_passed  = !local.has_overrides || local.justification_provided
}

# Security Controls Check Block
check "security_controls_compliance" {
  assert {
    condition     = local.flow_logs_validation_passed
    error_message = "Security control violation: VPC Flow Logs are required but enable_flow_logs is false. Set security_control_overrides.disable_flow_logs_requirement=true with justification if this is a dev/test VPC."
  }

  assert {
    condition     = local.private_subnets_validation_passed
    error_message = "Security control violation: Private subnets are required but private_subnet_cidrs is empty. Set security_control_overrides.disable_private_subnets_requirement=true with justification if this is intentional."
  }

  assert {
    condition     = local.nat_gateway_validation_passed
    error_message = "Security control violation: NAT Gateway is required but enable_nat_gateway is false. Set security_control_overrides.disable_nat_gateway_requirement=true with justification if this is intentional."
  }

  assert {
    condition     = local.kms_encryption_validation_passed
    error_message = "Security control violation: KMS customer-managed key is required for Flow Logs encryption but kms_key_arn is null. Set security_control_overrides.disable_kms_requirement=true with justification if this is intentional."
  }

  assert {
    condition     = local.override_audit_passed
    error_message = "Security control overrides detected but no justification provided. Please document the business reason in security_control_overrides.justification for audit compliance."
  }
}
