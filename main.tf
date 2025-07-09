resource "portainer_stack" "stacks" {
  for_each = local.stack_definitions

  name        = each.value.name
  deployment_type           = "standalone"
  method                    = "repository"
  endpoint_id               = 2
  repository_url            = "https://github.com/CyberViking949/portainer_stacks/stack_files"
  repository_reference_name = "refs/heads/main"
  file_path_in_repository   = "${each.value.name}.yaml"
  tlsskip_verify            = false

  # Optional GitOps enhancements:
  stack_webhook             = false                      # Enables GitOps webhook
  update_interval           = "1m"                       # Auto-update interval
  pull_image                = false                       # Pull latest image on update
  force_update              = false                       # Prune services not in compose file
  git_repository_authentication = true                   # If authentication is required
  repository_username       = var.gh_uname
  repository_password       = var.gh_pword
}