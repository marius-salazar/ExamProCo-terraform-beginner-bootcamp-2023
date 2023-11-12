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
    

    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

#provider "aws" {
  # Configuration options
#}



provider "random" {
  # Configuration options
}