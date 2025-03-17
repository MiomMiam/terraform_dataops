resource "google_bigquery_table" "transaction_fra" {

  project       = "terraform-dataops-dev"
  dataset_id    = "sale"
  table_id      = "transaction_fra"

  friendly_name = "Sales Transaction FRANCE"
  description   = "French sales transaction view without details"
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
      "description": "Unique identifier for the sales transaction."
    },
    {
      "name": "transaction_date",
      "type": "DATE",
      "description": "Date when the transaction occurred."
    },
    {
      "name": "transaction_time",
      "type": "TIME",
      "description": "Time when the transaction occurred."
    },
    {
      "name": "transaction_type_code",
      "type": "STRING",
      "description": "Unique identifier for the type of transaction (e.g., Sale, Return, Exchange)."
    },
    {
      "name": "customer_id",
      "type": "STRING",
      "description": "Unique identifier for the customer making the purchase if known."
    },
    {
      "name": "total_amount_including_tax",
      "type": "NUMERIC",
      "description": "Total amount for the transaction with taxes included"
    },
    {
      "name": "total_amount_excluding_tax",
      "type": "NUMERIC",
      "description": "Total amount for the transaction with taxes excluded"
    },
    {
      "name": "total_tax_amount",
      "type": "NUMERIC",
      "description": "Total tax amount for the transaction"
    },
    {
      "name": "total_discount_amount",
      "type": "NUMERIC",
      "description": "Total discount amount for the transaction"
    },
    {
      "name": "payment_method_code",
      "type": "STRING",
      "description": "Payment method used for the transaction (e.g., Credit Card, Cash, etc.)."
    },
    {
      "name": "transaction_status_label",
      "type": "STRING",
      "description": "Status of the transaction (e.g., Completed, Pending, Cancelled)."
    },
    {
      "name": "business_unit_code",
      "type": "STRING",
      "description": "Unique identifier for the business unit where the transaction occurred."
    },
    {
      "name": "store_code",
      "type": "STRING",
      "description": "Unique identifier for the store where the transaction occurred."
    },
    {
      "name": "register_code",
      "type": "STRING",
      "description": "Unique identifier for the register where the transaction occurred."
    },
    {
      "name": "employee_id",
      "type": "STRING",
      "description": "Unique identifier for the employee who processed the transaction."
    },
    {
      "name": "created_at",
      "type": "TIMESTAMP",
      "description": "technical field to capture the timestamp when the record was created."
    },
    {
      "name": "updated_at",
      "type": "TIMESTAMP",
      "description": "technical field to capture the timestamp when the record was last updated."
    },
    {
      "name": "created_by",
      "type": "STRING",
      "description": "User or system who created the transaction."
    },
    {
      "name": "updated_by",
      "type": "STRING",
      "description": "User or system who last updated the transaction."
    }
  ]
  EOF

  view {
    use_legacy_sql = false
    query = <<EOF
      SELECT
        *
      FROM
        `terraform-dataops-dev.sale.transaction`
      WHERE
        business_unit_code = 'FRA'
    EOF
  }

  depends_on = [
    google_bigquery_table.transaction
  ]
}
