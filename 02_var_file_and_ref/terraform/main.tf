terraform {
  backend "gcs" {
    bucket = "terraform-dataops-dev-state"
    prefix = "02_var_file_and_ref"
  }
}
