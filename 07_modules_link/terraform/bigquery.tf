module "bigquery" {
  source = "git@github-miom:MiomMiam/terraform_dataops_module.git//bigquery?ref=master"

  configuration_folder = "../bigquery"
  context              = local.context
}
