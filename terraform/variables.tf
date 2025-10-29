variable "project_name" {
  description = "Project name"
  type        = string
  default     = "sysadmin-infra"
}

variable "host_port" {
  description = "Host port to expose nginx"
  type        = number
  default     = 8080
}

variable "app_env" {
  description = "Application environment"
  type        = string
  default     = "dev"
}
