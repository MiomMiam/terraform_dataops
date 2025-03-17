locals {

  view_transaction_fra = {
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

    schema_file = "../schema/transaction_fra.json"

    view = {
      use_legacy_sql = false

      query = templatefile("../query/transaction_fra.sql", {
        env = local.env
      })

    }
  }

}

resource "google_bigquery_table" "transaction_fra" {

  project       = local.view_transaction_fra.project
  dataset_id    = local.view_transaction_fra.dataset_id
  table_id      = local.view_transaction_fra.table_id

  friendly_name = local.view_transaction_fra.friendly_name
  description   = local.view_transaction_fra.description
  deletion_protection = local.view_transaction_fra.deletion_protection

  labels = local.view_transaction_fra.labels

  schema = file(local.view_transaction_fra.schema_file)

  view {
    use_legacy_sql = local.view_transaction_fra.view.use_legacy_sql

    query = local.view_transaction_fra.view.query

  }

  depends_on = [
    google_bigquery_table.transaction
  ]
}
