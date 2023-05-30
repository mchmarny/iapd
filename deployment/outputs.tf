# Description: Outputs for the deployment

output "SERVICE_URI" {
  value = "https://${var.domain}"
}

output "SERVICE_IP" {
  value = module.lb-http.external_ip
}

output "SERVICE_DNA_A_RECORD" {
  value = "${var.domain}   A   ${module.lb-http.external_ip}"
}
