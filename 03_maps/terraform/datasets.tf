locals {

  dataset_sale = {
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

}

resource "google_bigquery_dataset" "sale" {

  project       = local.dataset_sale.project
  dataset_id    = local.dataset_sale.dataset_id
  location      = local.dataset_sale.location

  friendly_name = local.dataset_sale.friendly_name
  description   = local.dataset_sale.description

  labels        = local.dataset_sale.labels

  delete_contents_on_destroy = local.dataset_sale.delete_contents_on_destroy
}
