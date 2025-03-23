locals {

  tables = {
    for file in fileset(local.configuration_folder, "*/datasets/*/tables/*.yaml") :
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

}

resource "google_bigquery_table" "tables" {
  for_each = local.tables

  project       = google_bigquery_dataset.datasets[each.value.dataset_name].project
  dataset_id    = google_bigquery_dataset.datasets[each.value.dataset_name].dataset_id
  table_id      = each.value.content.table_id
  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)

  labels = lookup(each.value.content, "labels", null)

  schema                   = file("${local.configuration_folder}/${each.value.dir}/${each.value.content.schema_file}")
  clustering               = toset(lookup(each.value.content, "clustering_fields", null))

  expiration_time          = lookup(each.value.content, "expiration_time", null)
  deletion_protection      = lookup(each.value.content, "deletion_protection", true)
  require_partition_filter = lookup(each.value.content, "require_partition_filter", null)

  dynamic "range_partitioning" {
    for_each = lookup(each.value.content, "range_partitioning", null) != null ? [each.value.content.range_partitioning] : []
    content {
      field = each.value.content.range_partitioning.field
      range {
        start    = each.value.content.range_partitioning.start
        end      = each.value.content.range_partitioning.end
        interval = each.value.content.range_partitioning.interval
      }
    }
  }

  dynamic "time_partitioning" {
    for_each = lookup(each.value.content, "time_partitioning", null) != null ? [each.value.content.time_partitioning] : []
    content {
      type          = each.value.content.time_partitioning.type
      field         = lookup(each.value.content.time_partitioning, "field", null)
      expiration_ms = lookup(each.value.content.time_partitioning, "expiration_ms", null)
    }
  }

}
