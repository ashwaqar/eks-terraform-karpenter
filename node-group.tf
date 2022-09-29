# launch template is necessary because as per documentation
# Resource: aws_eks_node_group doesn't allow for modifying tags on your instances
# EC2 instances show up unnamed on the console

resource "aws_eks_node_group" "node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "${local.prefix}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  #   capacity_type = "ON_DEMAND"
  instance_types = ["t2.micro"]
  disk_size      = 50

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    module.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly
  ]

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    Name = "${local.prefix}-node-group"
  }
}

# resource "aws_eks_node_group" "node-group-1" {
#   cluster_name    = var.cluster_name
#   node_group_name = "${local.prefix}-node-group-1"
#   node_role_arn   = aws_iam_role.node.arn
#   subnet_ids      = module.vpc.private_subnets

#   scaling_config {
#     desired_size = var.desired_size
#     max_size     = var.max_size
#     min_size     = var.min_size
#   }

# #   capacity_type = "ON_DEMAND"
#   instance_types = ["t2.micro"]
#   disk_size      = 50

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     module.eks,
#     aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly
#   ]

#   lifecycle {
#     create_before_destroy = false
#   }

#   tags = {
#     Name = "${local.prefix}-node-group-1"
#   }
# }