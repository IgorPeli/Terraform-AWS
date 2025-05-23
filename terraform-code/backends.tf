terraform {
  backend "remote" {
    organization = "Igor_Terraform" # Troque pelo nome exato da sua organização
    hostname     = "app.terraform.io"

    workspaces {
      prefix = "terraform-aws" # Troque pelo nome exato do seu workspace
    }
  }
}
