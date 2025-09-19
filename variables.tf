variable "project_id" {
  description = "ID único del proyecto"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "billing_account" {
  description = "Cuenta de facturación (AAAAAA-BBBBBB-CCCCCC)"
  type        = string
}

variable "org_id" {
  description = "ID de organización (usa este o folder_id, no ambos). Déjalo null si no aplica."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "ID de carpeta (usa este o org_id, no ambos). Déjalo null si no aplica."
  type        = string
  default     = null
}

variable "region" {
  description = "Región por defecto"
  type        = string
  default     = "europe-west1"
}

variable "bq_location" {
  description = "Localización de BigQuery"
  type        = string
  default     = "EU"
}
