terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "03_maps"
  }
}
