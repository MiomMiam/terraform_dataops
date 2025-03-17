resource "google_bigquery_dataset" "sale" {

  project       = "terraform-dataops-dev"
  dataset_id    = "sale"
  location      = "EU"

  friendly_name = "Sales"
  description   = "Sales dataset for all BU"

  labels = {
    env = "dev"
    product = "retail"
  }

}
