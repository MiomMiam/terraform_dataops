terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "00_init"
  }
}
