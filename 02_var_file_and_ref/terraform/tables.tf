resource "google_bigquery_table" "transaction" {

  project       = local.dataops_project
  dataset_id    = google_bigquery_dataset.sale.dataset_id
  table_id      = "transaction"

  friendly_name = "Sales Transaction"
  description   = "Sales transaction table without details"
  deletion_protection = false

  labels = {
    env = local.env
    product = "retail"
  }

  schema = file("../schema/transaction.json")

  clustering = [
    "business_unit_code",
    "store_code"
  ]

  time_partitioning {
    type          = "DAY"
    field         = "transaction_date"
  }

}
