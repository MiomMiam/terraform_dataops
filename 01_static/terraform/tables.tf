resource "google_bigquery_table" "transaction" {

  project       = "terraform-dataops-dev"
  dataset_id    = "sale"
  table_id      = "transaction"

  friendly_name = "Sales Transaction"
  description   = "Sales transaction table without details"
  deletion_protection = false

  labels = {
    env = "dev"
    product = "retail"
  }

  schema = <<EOF
  [
    {
      "name": "transaction_id",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Unique identifier for the sales transaction."
    },
    {
      "name": "transaction_date",
      "type": "DATE",
      "mode": "REQUIRED",
      "description": "Date when the transaction occurred."
    },
    {
      "name": "transaction_time",
      "type": "TIME",
      "mode": "REQUIRED",
      "description": "Time when the transaction occurred."
    },
    {
      "name": "transaction_type_code",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Unique identifier for the type of transaction (e.g., Sale, Return, Exchange)."
    },
    {
      "name": "customer_id",
      "type": "STRING",
      "mode": "NULLABLE",
      "description": "Unique identifier for the customer making the purchase if known."
    },
    {
      "name": "total_amount_including_tax",
      "type": "NUMERIC",
      "mode": "REQUIRED",
      "description": "Total amount for the transaction with taxes included"
    },
    {
      "name": "total_amount_excluding_tax",
      "type": "NUMERIC",
      "mode": "REQUIRED",
      "description": "Total amount for the transaction with taxes excluded"
    },
    {
      "name": "total_tax_amount",
      "type": "NUMERIC",
      "mode": "REQUIRED",
      "description": "Total tax amount for the transaction"
    },
    {
      "name": "total_discount_amount",
      "type": "NUMERIC",
      "mode": "NULLABLE",
      "description": "Total discount amount for the transaction"
    },
    {
      "name": "payment_method_code",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Payment method used for the transaction (e.g., Credit Card, Cash, etc.)."
    },
    {
      "name": "transaction_status_label",
      "type": "STRING",
      "mode": "NULLABLE",
      "description": "Status of the transaction (e.g., Completed, Pending, Cancelled)."
    },
    {
      "name": "business_unit_code",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Unique identifier for the business unit where the transaction occurred."
    },
    {
      "name": "store_code",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Unique identifier for the store where the transaction occurred."
    },
    {
      "name": "register_code",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "Unique identifier for the register where the transaction occurred."
    },
    {
      "name": "employee_id",
      "type": "STRING",
      "mode": "NULLABLE",
      "description": "Unique identifier for the employee who processed the transaction."
    },
    {
      "name": "created_at",
      "type": "TIMESTAMP",
      "mode": "REQUIRED",
      "description": "technical field to capture the timestamp when the record was created."
    },
    {
      "name": "updated_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE",
      "description": "technical field to capture the timestamp when the record was last updated."
    },
    {
      "name": "created_by",
      "type": "STRING",
      "mode": "REQUIRED",
      "description": "User or system who created the transaction."
    },
    {
      "name": "updated_by",
      "type": "STRING",
      "mode": "NULLABLE",
      "description": "User or system who last updated the transaction."
    }
  ]
  EOF

  clustering = [
    "business_unit_code",
    "store_code"
  ]

  time_partitioning {
    type          = "DAY"
    field         = "transaction_date"
  }

  depends_on = [
    google_bigquery_dataset.sale
  ]

}
