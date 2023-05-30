locals {
  # List of roles that will be assigned to the runner service account
  runner_roles = toset([
    "roles/cloudsql.client",
    "roles/iam.serviceAccountTokenCreator",
    "roles/monitoring.metricWriter",
    "roles/pubsub.publisher",
  ])
}

# Service Account under which the Cloud Run services will run
resource "google_service_account" "runner_service_account" {
  account_id = "${var.name}-run-sa"
}

# Role binding to allow publisher to publish images
resource "google_project_iam_member" "runner_role_bindings" {
  for_each = local.runner_roles
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.runner_service_account.email}"
}

# App Cloud Run service 
resource "google_cloud_run_service" "app" {
  for_each                   = toset(var.regions)
  name                       = "${var.name}--${each.key}"
  location                   = each.value
  autogenerate_revision_name = true

  template {
    spec {
      containers {
        image = "${var.regions[0]}-docker.pkg.dev/${var.project}/${var.name}/app:${data.template_file.version.rendered}"
        startup_probe {
          http_get {
            path = "/health"
          }
        }
        ports {
          name           = "http1"
          container_port = 8080
        }
        resources {
          limits = {
            cpu    = "2000m"
            memory = "512Mi"
          }
        }
        env {
          name  = "LOG_LEVEL"
          value = var.log_level
        }
      }

      container_concurrency = 80
      timeout_seconds       = 300
      service_account_name  = google_service_account.runner_service_account.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = "0"
        "autoscaling.knative.dev/maxScale"         = "3"
        "run.googleapis.com/execution-environment" = "gen2"
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
      "run.googleapis.com/ingress"     = "internal-and-cloud-load-balancing"
      # all, internal, internal-and-cloud-load-balancing
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["run.googleapis.com/operation-id"],
    ]
  }
}

resource "google_cloud_run_service_iam_member" "app_public_access" {
  for_each = toset(var.regions)

  location = google_cloud_run_service.app[each.key].location
  project  = google_cloud_run_service.app[each.key].project
  service  = google_cloud_run_service.app[each.key].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
