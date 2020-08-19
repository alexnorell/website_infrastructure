terraform {
  backend "s3" {
    bucket = "alexnorell-tfstates"
    key    = "website"
    region = "us-west-1"
  }
}
