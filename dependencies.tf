# --- VPC, Subnets
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["dev-skokado-playground"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }

  filter {
    name   = "tag:IPv6Native"
    values = ["false"]
  }
}
data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}
