terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "terraform-state-aksil" 
    key            = "projet/eks-cluster/terraform.tfstate" # Le chemin où sera stocké le fichier
    region         = "us-east-1"
    encrypt        = true
    # Optionnel mais recommandé :
    # dynamodb_table = "terraform-lock" 
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
