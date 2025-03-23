locals {
  env = terraform.workspace
  zone = "EU"

  dataops_project = "terraform-dataops-${local.env}"
  exposed_project = "terraform-exposed-${local.env}"

  configuration_folder = "../bigquery"
}
