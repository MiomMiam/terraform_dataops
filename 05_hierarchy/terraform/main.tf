terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "05_hierarchy"
  }
}
