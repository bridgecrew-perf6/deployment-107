variable "install_db_tunneller" {
  description = "This installs DB Tunneller if set (Note For Dev Env)"
  type        = bool
  default     = true
}

variable "api_charts_version" {
  description = "API Charts Version"
  type        = string
  default     = "0.1.10"
}

variable "mariadb_charts_version" {
  description = "MariaDB Charts Version"
  type        = string
  default     = "11.0.2"
}

variable "ingess_nginx_charts_version" {
  description = "ingress-nginx Charts Version"
  type        = string
  default     = "11.0.2"
}

variable "argocd_charts_version" {
  description = "argocd Charts Version"
  type        = string
  default     = "4.5.11"
}

variable "socat_tunneller_charts_version" {
  description = "db tunneller Charts Version"
  type        = string
  default     = "0.1.2"
}

##################################################
# DNS Settings
##################################################

variable "api_host" {
  description = "API Host Header"
  type        = string
  default     = "api.localhost"
}