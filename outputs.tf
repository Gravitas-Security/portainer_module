output "published_stack_definitions" {
  value = local.published_stack_definitions
}

output "unpublished_stack_definitions" {
  value = local.unpublished_stack_definitions
}

output "cloudflare_access_group" {
  description = "Cloudflare access group"
  value       = cloudflare_zero_trust_access_group.group
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

# output "env_vars_map" {
#   value = {
#     for stack_name in keys(local.env_files_raw) :
#     stack_name => local.env_vars_map[stack_name]
#   }
# }

# output "env_files_raw"    {
#   value = local.env_files_raw
# }