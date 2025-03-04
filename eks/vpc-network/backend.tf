terraform {
  backend "s3" {
    bucket  = "edexa-mainnet-infra"  # Replace with your actual S3 bucket name
    key     = "vpc-network/terraform.tfstate"
    region  = "eu-central-1"  # Change to your preferred AWS region
    encrypt = true
  }
}
