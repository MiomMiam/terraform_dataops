
provider "google" {
  zone = local.zone

  scopes = [
    "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}
