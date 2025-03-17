
provider "google" {
  zone = "EU"

  scopes = [
    "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}
