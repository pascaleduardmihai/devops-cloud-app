module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "task-manager-cluster"
  cluster_version = "1.30" 

  cluster_endpoint_public_access = true

  # Legătura cu VPC-ul creat anterior
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Configurare Noduri (Worker Nodes)
  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      instance_types = ["t3.medium"] # Minim t3.medium pentru EKS (t3.micro e prea mic)
      capacity_type  = "SPOT"        
    }
  }

  # Permite accesul nodurilor la API Server
  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Project     = "task-manager"
  }
}
