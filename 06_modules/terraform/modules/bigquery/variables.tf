variable "configuration_folder" {
  description = "Contains the path to the root configuration folder of the module"
  type        = string
  default     = "../bigquery"
}

variable "context" {
  description = "Contains the context variables of the environment"
  type = object({
    location        = string
    env             = string
    dataops_project = string
    exposed_project = string
  })
}
