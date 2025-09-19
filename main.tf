############################################
# 1) Proyecto GCP
############################################
resource "google_project" "this" {
  project_id = var.project_id
  name       = var.project_name
}
# Doc: solo uno de org_id o folder_id puede especificarse. :contentReference[oaicite:1]{index=1}

############################################
# 2) Vincular facturación (necesario para BigQuery)
############################################
resource "google_billing_project_info" "billing" {
  project         = google_project.this.project_id
  billing_account = var.billing_account
}

############################################
# 3) Activar APIs necesarias
############################################
locals {
  apis = [
    "bigquery.googleapis.com",
    "iam.googleapis.com"
  ]
}

resource "google_project_service" "apis" {
  for_each           = toset(local.apis)
  project            = google_project.this.project_id
  service            = each.value
  disable_on_destroy = false
  depends_on         = [google_billing_project_info.billing]
}

############################################
# 4) Datasets de BigQuery (staging y data_mart)
############################################
resource "google_bigquery_dataset" "staging" {
  project    = google_project.this.project_id
  dataset_id = "staging"
  location   = var.bq_location
  depends_on = [google_project_service.apis]
}

resource "google_bigquery_dataset" "mart" {
  project    = google_project.this.project_id
  dataset_id = "data_mart"
  location   = var.bq_location
  depends_on = [google_project_service.apis]
}

############################################
# 5) Service Account + permisos mínimos BigQuery
############################################
resource "google_service_account" "dbt" {
  project      = google_project.this.project_id
  account_id   = "dbt-ci-sa"
  display_name = "Service Account for BigQuery (dbt/CI)"
  depends_on   = [google_project_service.apis]
}

# Puede lanzar jobs de BigQuery en el proyecto
resource "google_project_iam_member" "bq_job_user" {
  project = google_project.this.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt.email}"
}

# Puede editar datos en los dos datasets
resource "google_bigquery_dataset_iam_member" "staging_editor" {
  project    = google_project.this.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}
resource "google_bigquery_dataset_iam_member" "mart_editor" {
  project    = google_project.this.project_id
  dataset_id = google_bigquery_dataset.mart.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}
