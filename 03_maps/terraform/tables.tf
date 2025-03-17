locals {
  table_transaction = {

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

    schema_file   = "../schema/transaction.json"

    clustering    = [
      "business_unit_code",
      "store_code"
    ]

    time_partitioning = {
      type  = "DAY"
      field = "transaction_date"
    }
  }
}

resource "google_bigquery_table" "transaction" {

  project       = local.dataops_project
  dataset_id    = local.table_transaction.dataset_id
  table_id      = local.table_transaction.table_id

  friendly_name = local.table_transaction.friendly_name
  description   = local.table_transaction.description
  deletion_protection = local.table_transaction.deletion_protection

  labels = local.table_transaction.labels

  schema = file(local.table_transaction.schema_file)

  clustering = local.table_transaction.clustering

  time_partitioning {
    type  = local.table_transaction.time_partitioning.type
    field = local.table_transaction.time_partitioning.field
  }

}
