########################################
# Existing definitions (kept)
########################################
locals {
  published_stack_file_paths = fileset(var.published_stack_files_path, "*.y*ml")
  published_stack_definitions = {
    for file_path in local.published_stack_file_paths :
    trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml") => {
      name    = trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml")
      content = file("${var.published_stack_files_path}/${file_path}")
    }
  }

  unpublished_stack_file_paths = fileset(var.unpublished_stack_files_path, "*.y*ml")
  unpublished_stack_definitions = {
    for file_path in local.unpublished_stack_file_paths :
    trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml") => {
      name    = trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml")
      content = file("${var.unpublished_stack_files_path}/${file_path}")
    }
  }

  published_stack_order = sort(keys(local.published_stack_definitions))

  ########################################
  # NEW: env-file support for *both* groups
  ########################################
  env_dir          = "../env_files"
  # One relative path for every *.env file in env_dir
  env_file_paths = fileset(local.env_dir, "*.env")

   # union of all stack names
  all_stack_names = concat(
    keys(local.published_stack_definitions),
    keys(local.unpublished_stack_definitions),
  )

  # 2. Read the raw text of each .env file (empty string if none found)
  env_files_raw = {
  for name in local.all_stack_names :
  name => fileexists("${local.env_dir}/${name}.env")
    ? file("${local.env_dir}/${name}.env")
    : ""
}

  # 3. Parse the text into a list(object({ name = string, value = string }))
env_vars_map = {
    for n, raw in local.env_files_raw :
    n => [
      for match in regexall(
        "(?m)^\\s*([^#\\s][^=\\n]*)=([^\\n]*)$",
        raw
      ) : {
        name  = trimspace(match[0])
        value = trimspace(match[1])
      }
    ]
  }

  _all_stacks = merge(
    { for k, r in portainer_stack.published_stacks   : k => r },
    { for k, r in portainer_stack.unpublished_stacks : k => r }
  )
  stack_public_attrs = {
  for name, r in local._all_stacks :
  name => {
    id                            = r.id
    deployment_type               = r.deployment_type
    method                        = r.method
    repository_url                = r.repository_url
    file_path_in_repository       = r.file_path_in_repository
    update_interval               = r.update_interval
    force_update                  = r.force_update
    pull_image                    = r.pull_image
    git_repository_authentication = r.git_repository_authentication

    # ─── ENV: use parsed list directly ───────────────────
    # env = lookup(local.env_files_raw, name, [])
  }
}

}
