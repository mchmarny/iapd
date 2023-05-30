# Description: Variables for the deployment

variable "project" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "domain" {
  description = "Domain name"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Service name (iapd == Identity Aware Proxy Demo)"
  type        = string
  default     = "iapd"
}

variable "image" {
  description = "Demo app image URI (e.g. us-west1-docker.pkg.dev/s3cme1/iapd/app)"
  type        = string
  default     = "us-west1-docker.pkg.dev/s3cme1/iapd/app"
}

variable "rate_limit_threshold_min" {
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

variable "support_email" {
  type        = string
  description = "Email address for support"
  nullable    = false
}

variable "oauth_client_id" {
  type        = string
  description = "OAuth Client ID"
  nullable    = false
}

variable "oauth_client_secret" {
  type        = string
  description = "OAuth Client Secret"
  nullable    = false
}

variable "access_members" {
  type        = list(string)
  description = "List of members to grant access to the service"
  default     = []
}