locals {
  datasets = {
    for file in fileset(local.configuration_folder, "*/datasets/*/*.yaml") :
      "${split("/", dirname(file))[0]}_${trimsuffix(basename(file), ".yaml")}"
      => {
        content = yamldecode(templatefile(
          "${local.configuration_folder}/${file}",
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

  dataset_accesses = merge([
    for dataset_key, dataset in local.datasets : merge([
      for access_key, access in dataset.content.accesses : {
        for role in access.roles : "${dataset_key}_${access_key}_${role}" => {
          dataset_key    = dataset_key
          account_member = access.account_member
          account_type   = access.account_type
          role           = role
        }
      }
    ]...)
    if can(dataset.content["accesses"])
  ]...)

}

resource "google_bigquery_dataset" "datasets" {
  for_each = local.datasets

  project       = each.value.content.project
  dataset_id    = each.value.content.dataset_id
  location      = lookup(each.value.content, "location", local.zone)
  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)

  labels = lookup(each.value.content, "labels", null)

  default_table_expiration_ms     = lookup(each.value.content, "default_table_expiration_ms", null)
  default_partition_expiration_ms = lookup(each.value.content, "default_partition_expiration_ms", null)
  delete_contents_on_destroy      = lookup(each.value.content, "delete_contents_on_destroy", null)

  lifecycle {
    ignore_changes = [
      # so google_bigquery_dataset and google_bigquery_dataset_access don't fight
      # over which accesses should be on the dataset.
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_access
      access
    ]
  }
}

resource "google_bigquery_dataset_access" "dataset_accesses" {
  for_each = local.dataset_accesses

  project        = google_bigquery_dataset.datasets[each.value.dataset_key].project
  dataset_id     = google_bigquery_dataset.datasets[each.value.dataset_key].dataset_id
  role           = "roles/bigquery.${each.value.role}"
  user_by_email  = contains(["user", "serviceAccount"], each.value.account_type) ? each.value.account_member : null
  group_by_email = each.value.account_type == "group" ? each.value.account_member : null
  special_group  = each.value.account_type == "special" ? each.value.account_member : null
}
