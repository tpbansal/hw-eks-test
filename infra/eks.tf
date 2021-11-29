# ---------------------------------------------------------------------------------------------------------------------
# EKS CONTROL PLANE AND WORKER GROUPS
# ---------------------------------------------------------------------------------------------------------------------
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

## Tag your GIT repo for an "eventual" CI/CD Codebuild/pipeline

  tags = {
    Environment = "dribingtask"
    GithubRepo  = "cloudinfra"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id
  
  ## Setup a separate SG group for enabling ONLY private access to EKS API Server
  # cluster_endpoint_private_access = true
  # cluster_endpoint_public_access  = false

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}
