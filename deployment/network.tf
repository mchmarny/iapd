# Serverless Network Endpoint Groups (NEGs) for HTTPS LB to CLoud Run services
module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "9.0.0"
  name    = var.name
  project = var.project

  create_address = false
  address        = google_compute_global_address.http_lb_address.address

  ssl                             = true
  managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = true

  backends = {
    default = {
      description                     = null
      enable_cdn                      = false
      security_policy                 = google_compute_security_policy.policy.name
      edge_security_policy            = null
      custom_request_headers          = null
      custom_response_headers         = null
      compression_mode                = null
      protocol                        = "HTTPS"
      port_name                       = "http"
      compression_mode                = "DISABLED"
      connection_draining_timeout_sec = 300

      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg[each.key]
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }
    }
  }

  depends_on = [
    google_project_service.compute_engine,
    google_compute_global_address.http_lb_address,
  ]
}

# Region network endpoint group for Cloud Run sercice in that region
resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  for_each = toset(var.regions)

  name                  = "${var.name}--neg--${each.key}"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_service.app[each.key].location

  cloud_run {
    service = google_cloud_run_service.app[each.key].name
  }
}


