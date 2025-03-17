module "bigquery" {
  source = "./modules/bigquery"

  configuration_folder = "../bigquery"
  context              = local.context
}
