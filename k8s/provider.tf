provider "google" {
  credentials = file("../../../../../fabled-ray-333502-6752a983554b.json")
  project     = "fabled-ray-333502"
  region      = "asia-southeast2"
  version     = "~> 2.5.0"
}