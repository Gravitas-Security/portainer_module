variable "published_stack_files_path" {
  description = "Path to the directory containing Portainer stack YAML files that will be published through Cloudflare"
  type        = string
}

variable "unpublished_stack_files_path" {
  description = "Path to the directory containing Portainer stack YAML files that will be internal only"
  type        = string
}

variable "env_dir" {
  description = "Absolute path to the env_files directory"
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

variable "portainer_uname" {
  type      = string
  sensitive = true
}

variable "portainer_pword" {
  type      = string
  sensitive = true
}

variable "portainer_endpoint" {
  type      = string
  sensitive = true
}

variable "cf_domain" {
  type    = string
  default = "domain"
}

variable "cf_account_name" {
  type = string
}