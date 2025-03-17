locals {

  tables = {
    for file in fileset("../", "tables/*.yaml") :
      trimsuffix(basename(file), ".yaml") # key
      => {
        content = yamldecode(templatefile(
          "../${file}",
          {
            env = local.env,
            location = local.zone,
            dataops_project = local.dataops_project
          }
        ))

        path = file
        dir  = dirname(file)
      }
  }
}

resource "google_bigquery_table" "tables" {
  for_each = local.tables

  project       = each.value.content.project
  dataset_id    = google_bigquery_dataset.datasets[each.value.content.dataset_id].dataset_id
  table_id      = each.value.content.table_id

  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)
  deletion_protection = lookup(each.value.content, "deletion_protection", false)

  labels        = lookup(each.value.content, "labels", null)

  schema = file("../${each.value.dir}/${each.value.content.schema_file}")

  clustering = toset(lookup(each.value.content, "clustering", null))

  dynamic "time_partitioning" {
    for_each = lookup(each.value.content, "time_partitioning", null) != null ? [each.value.content.time_partitioning] : []
    content {
      type          = time_partitioning.value.type
      field         = lookup(time_partitioning.value, "field", null)
      expiration_ms = lookup(time_partitioning.value, "expiration_ms", null)
    }
  }
}
