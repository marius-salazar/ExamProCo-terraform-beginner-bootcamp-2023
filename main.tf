terraform {

 #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "marius_salazar"
#
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

   cloud {
    organization = "marius_salazar"

    workspaces {
      name = "terra-house-1"
    }
  }


  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  # Configuration options
}



provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  lower            = true
  upper            = false
  length           = 32
  special          = false
}



resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.id

}

output "random_bucket_name" {
  value = random_string.bucket_name.id
}


