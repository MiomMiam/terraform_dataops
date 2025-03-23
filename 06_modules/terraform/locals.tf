locals {
  env = terraform.workspace
  zone = "EU"

  dataops_project = "terraform-dataops-${local.env}"
  exposed_project = "terraform-exposed-${local.env}"

  context = {
    env = local.env
    location = local.zone
    dataops_project = local.dataops_project
    exposed_project = local.exposed_project
  }
}
