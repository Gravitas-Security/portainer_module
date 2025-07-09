resource "portainer_stack" "stacks" {
  for_each = local.stack_definitions

  name        = "${each.value.name}"
  deployment_type           = "standalone"
  method                    = "repository"
  endpoint_id               = 2
  repository_url            = "https://github.com/CyberViking949/portainer_stacks"
  repository_reference_name = "refs/heads/main"
  file_path_in_repository   = "/stack_files/${each.value.name}.yaml"
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


resource "cloudflare_zero_trust_access_application" "access_app" {
  for_each = local.stack_definitions
  zone_id    = data.cloudflare_zones.zones.zones[0].id
  domain     = "${each.key}.${var.cf_domain}"
  name       = each.key
  depends_on = [cloudflare_zero_trust_access_group.group]
  lifecycle {
    ignore_changes = [zone_id]
  }
}

data "cloudflare_accounts" "account" {
  name = var.cf_account_name
}

data "cloudflare_zones" "zones" {
  filter {
    name = var.domain
  }
}

resource "cloudflare_zero_trust_access_group" "group" {
  for_each = { for group in var.group : group.name => group }
  zone_id  = data.cloudflare_zones.zones.zones[0].id
  name     = each.value.name
  dynamic "include" {
    for_each = try(each.value.include, null) != null ? [each.value] : []
    content {
      login_method = try(each.value.include["login_method"], null)
    }
  }
  lifecycle {
    ignore_changes = [id, zone_id]
  }
}

resource "cloudflare_zero_trust_access_policy" "app_policy" {
  for_each = local.stack_definitions
  zone_id        = data.cloudflare_zones.zones.zones[0].id
  application_id = cloudflare_zero_trust_access_application.access_app[each.key].id
  name           = "${each.key}.${var.domain} Access Policy"
  decision       = (each.value.decision) == null ? "allow" : each.value.action
  precedence     = index(local.stack_definitions, each.value) + 1
  dynamic "include" {
    for_each = try(each.value, null) != null ? [each.value] : []
    content {
      #login_method      = try(each.value.login_method, null)
      group = [cloudflare_zero_trust_access_group.group[each.value.group].id]
      #everyone          = try(each.value.everyone, null)
    }
  }
  lifecycle {
    ignore_changes = [ zone_id ]
  }
  depends_on = [cloudflare_zero_trust_access_application.access_app]
}




