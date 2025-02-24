terraform {
  backend "s3" {
    bucket = "gdl-jenkins-app-kub-2025-v2"
    region = "ap-south-1"
    key = "eks/gdl-role-policy-terraform.tfstate"
  }
}