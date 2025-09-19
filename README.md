# GCP Project Deployment with Terraform

Minimal infrastructure for **Terraform (IaC)** of the coding challenge:

- Create a **GCP project** with Terraform (with billing).
- Create **BigQuery datasets**: `staging` and `data_mart`.
- Create a **Service Account** with BigQuery permissions.
- **Everything via Terraform** (no manual resources).

---

## 1) Requirements

- **GCP account** with access to a **Billing Account**.
- **Cloud Shell** (recommended) or any environment with:
  - Terraform ≥ 1.5
  - gcloud SDK (if not using Cloud Shell)

In Cloud Shell, application credentials are already configured.

---

## 2) Clone the repository

```bash
git clone https://github.com/Soniaremacha/GCP-project-deployment-with-Terraform.git
cd GCP-project-deployment-with-Terraform
```

## 3) Terraform variables

This repo does not version `terraform.tfvars`. An example file is included:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values.
Check `variables.tf` for the names and types of required variables.

Sample (adjust to your own `variables.tf`):
```bash
project_id      = "my-astrafy-project"
billing_account = "XXXXXX-XXXXXX-XXXXXX"
org_id          = ""        # Or folder_id if applicable
folder_id       = ""        # Leave empty if not applicable
region          = "europe-west1"
bq_location     = "EU"      # BigQuery location (e.g., EU/US)
```

## 4) Initialize and validate
```bash
terraform fmt -recursive
terraform init
terraform validate
```

## 5) Plan and Apply
```bash
terraform plan -out tfplan
terraform apply tfplan
```
Terraform will create:

- GCP Project with billing.

- BigQuery datasets: `staging` and `data_mart`.

- Service Account with minimal BigQuery roles applied through IAM.


## 6) Quick verification

In Google Cloud Console:

- Project: visible and linked with Billing.

- BigQuery: datasets `staging` and `data_mart`.

- IAM → Service Accounts: the created account with its roles (e.g., `bigquery.jobUser`, `bigquery.dataEditor`).


## 7) Destroy (optional)
```bash
terraform destroy
```

## 8) Repo good practices

`.gitignore` includes:

- `*.tfvars`

- Terraform state files

Only `terraform.tfvars.example` (placeholders) is published.
Keep your real `terraform.tfvars` local only.


## 9) Common issues

Push rejected due to remote changes:
```bash
git pull --rebase origin main
git push origin main
```

Credentials in Cloud Shell: already available by default.
If you need them manually:
```bash
gcloud auth application-default login
```

## 10) Project structure (minimal)

- `main.tf` – main resources (project, datasets, SA, IAM).

- `providers.tf` – google/google-beta provider.

- `variables.tf` – variable definitions.

- `terraform.tfvars.example` – variable template.


