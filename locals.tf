locals {
  stack_file_paths = fileset(var.stack_files_path, "*.y*ml")

  stack_definitions = {
    for file_path in local.stack_file_paths :
    trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml") => {
      name    = trimsuffix(trimsuffix(basename(file_path), ".yaml"), ".yml")
      content = file("${var.stack_files_path}/${file_path}")
    }
  }

  stack_order = sort(keys(local.stack_definitions))
}