terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "04_files"
  }
}
