# External IP to use in SSL cert on LB
resource "google_compute_global_address" "http_lb_address" {
  name  = var.name

  address_type = "EXTERNAL"
  ip_version   = "IPV4"

  lifecycle {
    prevent_destroy = true
  }
}
