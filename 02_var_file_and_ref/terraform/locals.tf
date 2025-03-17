locals {
  env = terraform.workspace
  zone = "EU"

  dataops_project = "terraform-dataops-${local.env}"
}
