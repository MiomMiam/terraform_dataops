resource "google_bigquery_table" "transaction_fra" {

  project       = local.dataops_project
  dataset_id    = google_bigquery_dataset.sale.dataset_id
  table_id      = "transaction_fra"

  friendly_name = "Sales Transaction FRANCE"
  description   = "French sales transaction view without details"
  deletion_protection = false

  labels = {
    env = local.env
    product = "retail"
  }

  schema = file("../schema/transaction_fra.json")

  view {
    use_legacy_sql = false

    query = templatefile("../query/transaction_fra.sql", {
      env = local.env
    })

  }

  depends_on = [
    google_bigquery_table.transaction
  ]
}
