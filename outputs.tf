output "published_stack_definitions" {
  value = local.published_stack_definitions
}

output "unpublished_stack_definitions" {
  value = local.unpublished_stack_definitions
}

output "cloudflare_access_application" {
  description = "Access Application"
  value       = cloudflare_zero_trust_access_application.access_app
}

output "cloudflare_access_policy" {
  description = "Access Application Policies"
  value       = cloudflare_zero_trust_access_policy.app_policy
}

output "stack_public_attributes" {
  description = "Per-stack ID, endpoint and status (no secrets)"
  value       = local.stack_public_attrs[*]
}