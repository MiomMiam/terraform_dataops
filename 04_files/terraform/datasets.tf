locals {

  datasets = {
    for file in fileset("../", "datasets/*.yaml") :
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

resource "google_bigquery_dataset" "datasets" {
  for_each = local.datasets

  project       = each.value.content.project
  dataset_id    = each.value.content.dataset_id
  location      = each.value.content.location

  friendly_name = lookup(each.value.content, "friendly_name", null)
  description   = lookup(each.value.content, "description", null)

  labels        = lookup(each.value.content, "labels", null)

  delete_contents_on_destroy = lookup(each.value.content, "delete_contents_on_destroy", false)
}
