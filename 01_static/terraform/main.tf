terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "01_static"
  }
}
