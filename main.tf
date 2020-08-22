provider "aws" {
  version = "~> 3.2"
  region  = "us-west-1"
}

provider "aws" {
  version = "~> 3.2"
  region  = "us-east-1"
  alias   = "us_east_1"
}