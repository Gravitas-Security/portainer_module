resource "portainer_stack" "published_stacks" {
  for_each = local.published_stack_definitions

  name                      = "${each.value.name}"
  deployment_type           = "standalone"
  method                    = "repository"
  endpoint_id               = 2
  repository_url            = "https://github.com/CyberViking949/portainer_stacks"
  repository_reference_name = "refs/heads/main"
  file_path_in_repository   = "/published_stack_files/${each.value.name}.yaml"
  tlsskip_verify            = false

  # Optional GitOps enhancements:
  stack_webhook                 = false                      # Enables GitOps webhook
  update_interval               = "1m"                       # Auto-update interval
  pull_image                    = false                       # Pull latest image on update
  force_update                  = true                       # Prune services not in compose file
  git_repository_authentication = true                   # If authentication is required
  repository_username           = var.gh_uname
  repository_password           = var.gh_pword

  dynamic "env" {
  for_each = lookup(local.env_vars_map, each.key, [])

  content {
    name  = env.value.name
    value = env.value.value
  }
}

}

resource "portainer_stack" "unpublished_stacks" {
  for_each = local.unpublished_stack_definitions

  name                      = "${each.value.name}"
  deployment_type           = "standalone"
  method                    = "repository"
  endpoint_id               = 2
  repository_url            = "https://github.com/CyberViking949/portainer_stacks"
  repository_reference_name = "refs/heads/main"
  file_path_in_repository   = "/unpublished_stack_files/${each.value.name}.yaml"
  tlsskip_verify            = false

  # Optional GitOps enhancements:
  stack_webhook                 = false                      # Enables GitOps webhook
  update_interval               = "1m"                       # Auto-update interval
  pull_image                    = false                       # Pull latest image on update
  force_update                  = true                       # Prune services not in compose file
  git_repository_authentication = true                   # If authentication is required
  repository_username           = var.gh_uname
  repository_password           = var.gh_pword

  dynamic "env" {
    for_each = lookup(local.env_vars_map, each.key, [])

    content {
      name  = env.value.name
      value = env.value.value
    }
  }
}


resource "cloudflare_zero_trust_access_application" "access_app" {
  for_each = local.published_stack_definitions
  zone_id    = data.cloudflare_zones.zones.zones[0].id
  domain     = "${each.key}.${var.cf_domain}"
  name       = each.key
  policies = [ cloudflare_zero_trust_access_policy.app_policy.id ]
  lifecycle {
    ignore_changes = [zone_id]
  }
}

data "cloudflare_accounts" "account" {
  name = var.cf_account_name
}

data "cloudflare_zones" "zones" {
  filter {
    name = var.cf_domain
  }
}

resource "cloudflare_zero_trust_access_policy" "app_policy" {
  account_id = data.cloudflare_accounts.account.accounts[0].id
  name           = "${var.cf_domain} Access Policy"
  decision       = "allow"
  include {
      login_method = ["fde5709d-c4a5-4a52-b368-dba11118f38b"]
  }
  lifecycle {
    create_before_destroy = true
  }
}




