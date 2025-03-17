locals {

  views = {
    for file in fileset("../", "views/*.yaml") :
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

resource "google_bigquery_table" "views" {
  for_each = local.views

  project       = each.value.content.project
  dataset_id    = google_bigquery_dataset.datasets[each.value.content.dataset_id].dataset_id
  table_id      = each.value.content.view_id

  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)
  deletion_protection = lookup(each.value.content, "deletion_protection", false)

  labels = lookup(each.value.content, "labels", null)

  schema = file("../${each.value.dir}/${each.value.content.schema_file}")

  view {
    use_legacy_sql = lookup(each.value.content, "use_legacy_sql", false)

    query = templatefile("../${each.value.dir}/${each.value.content.query_file}", {
      env = local.env
    })

  }

  depends_on = [
    google_bigquery_table.tables
  ]
}
