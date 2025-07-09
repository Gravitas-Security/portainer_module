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
}