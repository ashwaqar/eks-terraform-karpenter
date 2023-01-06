output "prs" {
  value = data.aws_subnets.private.ids
}
output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "vpc_owner_id" {
  value = data.aws_vpc.selected.owner_id
}