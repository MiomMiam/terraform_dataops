resource "google_bigquery_dataset" "sale" {

  project       = local.dataops_project
  dataset_id    = "sale"
  location      = local.zone

  friendly_name = "Sales"
  description   = "Sales dataset for all BU"

  labels = {
    env = local.env
    product = "retail"
  }

  delete_contents_on_destroy = true
}
