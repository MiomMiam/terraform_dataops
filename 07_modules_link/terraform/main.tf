terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "07_modules_link"
  }
}
