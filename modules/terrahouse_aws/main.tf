terraform{

    required_providers {
    

    aws = {
      source = "hashicorp/aws"
       version = "5.26.0"
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
data "aws_caller_identity" "current" {}

