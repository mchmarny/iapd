# Description: This file contains the Terraform code to enable the required GCP APIs for the project

# List of GCP APIs to enable in this project
locals {
  services = [
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "monitoring.googleapis.com",
    "run.googleapis.com",
    "servicecontrol.googleapis.com",
    "servicemanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
  ]
}

# Data source to access GCP project metadata 
data "google_project" "project" {}

# Data source to default GCP network
data "google_compute_network" "default" {
  name = "default"
}


# Enable the required GCP APIs
resource "google_project_service" "default" {
  for_each = toset(local.services)

  project = var.project
  service = each.value

  disable_on_destroy = false
}

resource "google_project_service" "compute_engine" {
  provider = google-beta
  project  = var.project
  service  = "compute.googleapis.com"

  disable_on_destroy = true
}

resource "google_project_service" "service_networking" {
  provider = google-beta
  project  = var.project
  service  = "servicenetworking.googleapis.com"

  disable_on_destroy = true
}
