variable "stack_files_path" {
  description = "Path to the directory containing Portainer stack YAML files"
  type        = string
}

variable "gh_uname" {
  type      = string
  sensitive = true
}

variable "gh_pword" {
  type      = string
  sensitive = true
}