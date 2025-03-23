locals {
  views = {
    for file in fileset(local.configuration_folder, "*/datasets/*/views/*.yaml") :
      "${split("/", dirname(file))[0]}_${split("/", dirname(file))[2]}_${trimsuffix(basename(file), ".yaml")}"
      => {
        content = yamldecode(templatefile(
          "${local.configuration_folder}/${file}",
          {
            env = local.env,
            location = local.zone,
            dataops_project = local.dataops_project
          }
        ))
        path         = file
        dir          = dirname(file)
        dataset_name = "${split("/", dirname(file))[0]}_${split("/", dirname(file))[2]}"
      }
  }

  authorized_views = merge([
    for view_key, view in local.views : merge([
      for project_key, project in view.content.authorized_views : {
        for dataset in project :
        "${view_key}_${project_key}_${dataset}" => {
          project    = project_key
          dataset_id = dataset
          view_key   = view_key
        }
      }
    ]...)
    if can(view.content["authorized_views"])
  ]...)

}

resource "google_bigquery_table" "views" {
  for_each = local.views

  project       = google_bigquery_dataset.datasets[each.value.dataset_name].project
  dataset_id    = google_bigquery_dataset.datasets[each.value.dataset_name].dataset_id
  table_id      = each.value.content.view_id
  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)

  labels = lookup(each.value.content, "labels", null)

  schema              = file("${local.configuration_folder}/${each.value.dir}/${each.value.content.schema_file}")
  deletion_protection = lookup(each.value.content, "deletion_protection", false)

  view {
    query = templatefile(
      "${local.configuration_folder}/${each.value.dir}/${each.value.content.query_file}",
      {
        env = local.env,
        location = local.zone,
        dataops_project = local.dataops_project
      }
    )

    use_legacy_sql = lookup(each.value.content, "use_legacy_sql", false)
  }

  depends_on = [
    google_bigquery_table.tables
  ]
}

resource "google_bigquery_dataset_access" "authorized_views" {
  for_each = local.authorized_views

  project    = each.value.project
  dataset_id = each.value.dataset_id

  view {
    project_id = google_bigquery_table.views[each.value.view_key].project
    dataset_id = google_bigquery_table.views[each.value.view_key].dataset_id
    table_id   = google_bigquery_table.views[each.value.view_key].table_id
  }

  depends_on = [
    google_bigquery_dataset.datasets,
    google_bigquery_table.views
  ]
}
