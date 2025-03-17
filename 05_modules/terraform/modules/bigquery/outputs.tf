output "datasets" {
  value       = google_bigquery_dataset.datasets
  description = "Bigquery dataset ressources"
}

output "dataset_accesses" {
  value       = google_bigquery_dataset_access.dataset_accesses
  description = "Bigquery dataset access ressources"
}

output "tables" {
  value       = google_bigquery_table.tables
  description = "Bigquery table ressources"
}

output "views" {
  value       = google_bigquery_table.views
  description = "Bigquery view ressources"
}

output "authorized_views" {
  value       = google_bigquery_dataset_access.authorized_views
  description = "Bigquery authorized view ressources"
}


output "dataset_ids" {
  value = {
    for dataset_key, dataset in google_bigquery_dataset.datasets :
    dataset_key => {
      project    = dataset.project
      dataset_id = dataset.dataset_id
    }
  }
  description = "Unique id for the dataset being provisioned"
}
