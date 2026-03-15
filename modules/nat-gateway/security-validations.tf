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
  }

  # High availability check
  is_highly_available = length(var.public_subnet_ids) > 1

  # Apply overrides to security controls
  # Controls are enforced UNLESS explicitly overridden with justification
  ha_required = local.security_controls.compliance.enable_deletion_protection && !var.security_control_overrides.disable_high_availability

  # Validation results
  ha_validation_passed = !local.ha_required || local.is_highly_available

  # Audit trail for overrides
  has_overrides          = var.security_control_overrides.disable_high_availability
  justification_provided = var.security_control_overrides.justification != ""
  override_audit_passed  = !local.has_overrides || local.justification_provided
}

# Security Controls Check Block
check "security_controls_compliance" {
  assert {
    condition     = local.ha_validation_passed
    error_message = "Security control violation: High availability requires NAT Gateways in multiple availability zones. Provide multiple public_subnet_ids or set security_control_overrides.disable_high_availability=true with justification for development/test environments."
  }

  assert {
    condition     = local.override_audit_passed
    error_message = "Security control overrides detected but no justification provided. Please document the business reason in security_control_overrides.justification for audit compliance."
  }
}
