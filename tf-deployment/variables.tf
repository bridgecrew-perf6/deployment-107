variable "install_db_tunneller" {
  description = "This installs DB Tunneller if set (Note For Dev Env)"
  type        = bool
  default     = true
}

variable "api_charts_version" {
  description = "API Charts Version"
  type        = string
  default     = "0.1.9"
}