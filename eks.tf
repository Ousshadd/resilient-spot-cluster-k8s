module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "pfe-spot-cluster"
  cluster_version = "1.30" # La version li t-fahmna 3liha

  # Irtibat b l-VPC dyal Oussama
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Khalli l-cluster y-koun public bach t-qdrou t-khdmou b kubectl
  cluster_endpoint_public_access = true

  # Configuration dyal les Nodes (Spot Instances)
  eks_managed_node_groups = {
    spot_workers = {
      # Isti3mal Spot Instances bach t-nqqss 90% d l-taman
      capacity_type  = "SPOT"
      instance_types = ["t3.medium", "t3.small"] # Diversification bach t-fada interruption

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # Tags daroryin l-AWS
      
      labels = {
        role = "spot-worker"
      }
    }
  }

  # Darori bach t-fada machakil d l-Access li chfti f KMS
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "pfe"
    Terraform   = "true"
  }
}


module "eks_spot_nodes" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = module.eks_cluster.cluster_name
  cluster_version = "1.30"

  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    spot_workers = {
      capacity_type  = "SPOT"
      instance_types = ["t3.medium", "t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        role = "spot-worker"
      }
    }

  }

  depends_on = [module.eks_cluster]
}

/*
module "eks_cluster" {
source = "terraform-aws-modules/eks/aws"
version = "~> 20.0"

cluster_name = "pfe-spot-cluster"
cluster_version = "1.30"

vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.private_subnets
control_plane_subnet_ids = module.vpc.private_subnets

cluster_endpoint_public_access = true

enable_cluster_creator_admin_permissions = true

tags = {
Environment = "pfe"
Terraform = "true"
}
} */
