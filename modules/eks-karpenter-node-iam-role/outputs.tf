output "aws_iam_role_policy_attachment_karpenter_ssm_policy" {
  value = aws_iam_role_policy_attachment.karpenter_ssm_policy
}

output "aws_iam_instance_profile_karpenter_name" {
  value = aws_iam_instance_profile.karpenter.name
}

output "aws_iam_instance_profile_karpenter" {
  value = aws_iam_instance_profile.karpenter
}