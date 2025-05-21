terraform {
  backend "remote" {
    organization = "Igor_Terraform" # Troque pelo nome exato da sua organização

    workspaces {
      name = "terraform-aws" # Troque pelo nome exato do seu workspace
    }
  }
}
