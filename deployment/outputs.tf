# Description: Outputs for the deployment

output "SERVICE_URI" {
  value = "https://${var.domain}"
}

output "SERVICE_IP" {
  value = module.lb-http.external_ip
}
