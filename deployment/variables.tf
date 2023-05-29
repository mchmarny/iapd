variable "name" {
  description = "Service name (iapd == Identity Aware Proxy Demo)"
  type        = string
  default     = "iapd"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "domain" {
  description = "Domain name"
  type        = string
  nullable    = false
}

variable "image" {
  description = "container image to deploy"
  type        = string
  nullable    = false
}

variable "rate_limit_threshold_count_per_min" {
  description = "Request rate limit threshold per minute"
  type        = number
  default     = 100
}

variable "regions" {
  description = "list of GPC regions to deploy to"
  type        = list(any)
  default     = ["us-west1", "europe-west1", "asia-east1"]
}

variable "log_level" {
  type        = string
  description = "level of logging to use in the container (e.g. panic, fatal, error, warn, info, debug, trace)"
  default     = "info"
}