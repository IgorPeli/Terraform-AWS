terraform {
  backend "remote" {
    organization = "Igor_Terraform"
    hostname     = "app.terraform.io"
    workspace    = "terraform-aws"
  }
}