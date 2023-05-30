resource "google_project_service" "project_service" {
  project = var.project
  service = "iap.googleapis.com"
}

resource "google_iap_brand" "project_brand" {
  support_email     = var.support_email
  application_title = "${var.name} demo"
  project           = google_project_service.project_service.project
}

resource "google_iap_client" "project_client" {
  display_name = var.name
  brand        = google_iap_brand.project_brand.name
}

resource "google_iap_web_backend_service_iam_binding" "binding" {
  project             = google_project_service.project_service.project
  web_backend_service = module.lb-http.backend_services.default.self_link
  role                = "roles/iap.httpsResourceAccessor"
  members             = var.access_members
}
