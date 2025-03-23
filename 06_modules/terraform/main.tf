terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "06_modules"
  }
}
