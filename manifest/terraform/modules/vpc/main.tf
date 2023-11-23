

# main.tf
locals {
  create_prod_vpc       = var.create_prod_vpc
  create_manage_vpc       = var.create_manage_vpc
  create_dev_vpc       = var.create_dev_vpc
  create_manage_to_prod_peer = var.create_manage_to_prod_peer
  manage_route_table_ids  = aws_default_route_table.manage-rtb-public[*].id
  dev_route_table_ids  = aws_default_route_table.dev-rtb-public[*].id
  prod_route_table_ids  = concat(aws_default_route_table.prod-rtb-public[*].id, aws_route_table.prod-rtb-private[*].id)
  dev_env              = var.dev_env
  manage_env              = var.manage_env
  prod_env              = var.prod_env
  game_code          = var.game_code
  dev_game_code        = var.dev_game_code == null ? var.game_code : var.dev_game_code
  manage_game_code        = var.manage_game_code == null ? var.game_code : var.manage_game_code
  prod_game_code        = var.prod_game_code == null ? var.game_code : var.prod_game_code
  dev_owneprod_id         = var.dev_owneprod_id
  dev_access_key       = var.dev_access_key
  dev_secret_key       = var.dev_secret_key
  dev_session_token    = var.dev_session_token
  dev_region           = var.dev_region == null ? null : var.dev_region
  manage_region           = var.manage_region == null ? var.aws_region : var.manage_region
  prod_region           = var.prod_region == null ? var.aws_region : var.prod_region
}

# VPC
data "aws_calleprod_identity" "current" {}

provider "aws" {
  alias  = "prod"
  region = try(local.manage_region, local.prod_region)

}

provider "aws" {
  alias  = "dev"
  region = var.dev_region

  access_key = try(local.dev_access_key, null)
  secret_key = try(local.dev_secret_key, null)
  token      = try(local.dev_session_token, null)
}


resource "aws_vpc" "prod-vpc" {
  count = local.create_prod_vpc ? 1 : 0

  cidprod_block           = var.prod_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "prod-vpc-${var.game_code}-${var.region}"
  }
}

resource "aws_vpc" "dev-vpc" {
  count                = local.create_dev_vpc ? 1 : 0
  provider             = aws.dev
  cidprod_block           = var.dev_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "dev-vpc-${var.game_code}-${var.region}"
  }
}

resource "aws_vpc" "manage-vpc" {
  count = local.create_manage_vpc ? 1 : 0

  cidprod_block           = var.manage_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "manage-vpc-${var.game_code}-${var.region}"
  }
}

# internet gateway
resource "aws_internet_gateway" "dev_igw" {
  count = local.create_dev_vpc ? 1 : 0

  provider = aws.dev
  vpc_id   = aws_vpc.dev-vpc[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("dev-igw-%s-%s", var.game_code, var.region)
    },
  )
}

resource "aws_internet_gateway" "manage_igw" {
  count = local.create_manage_vpc ? 1 : 0

  vpc_id = try(aws_vpc.manage-vpc[0].id, var.manage_vpc_id)

  tags = merge(
    var.tags,
    {
      "Name" = format("manage-igw-%s-%s", var.game_code, var.region)
    },
  )
}

resource "aws_internet_gateway" "prod_igw" {
  count = local.create_prod_vpc ? 1 : 0

  vpc_id = aws_vpc.prod-vpc[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-igw-%s-%s", var.game_code, var.region)
    },
  )
}

# public subnet
resource "aws_subnet" "prod-sn-public" {
  count = local.create_prod_vpc ? length(var.prod_public_subnets) : 0

  # count = length(var.prod_public_subnets)

  vpc_id                  = aws_vpc.prod-vpc[0].id
  cidprod_block              = var.prod_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"                          = format("prod-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet"                        = "prod-sn-public"
      "karpenter.sh/discovery"        = "${cluster_id}"
      "kubernetes.io/cluster/${cluster_id}" = "shared"
      "kubernetes.io/role/elb"        = "1"
    },
  )
}

resource "aws_subnet" "dev-sn-public" {
  count = local.create_dev_vpc ? length(var.dev_public_subnets) : 0

  # count = length(var.dev_public_subnets)
  provider                = aws.dev
  vpc_id                  = aws_vpc.dev-vpc[0].id
  cidprod_block              = var.dev_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"   = format("dev-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet" = "dev-sn-public"
    },
  )
}

resource "aws_subnet" "manage-sn-public" {
  count = local.create_manage_vpc ? length(var.manage_public_subnets) : 0

  # count = length(var.manage_public_subnets)

  vpc_id                  = try(aws_vpc.manage-vpc[0].id, var.manage_vpc_id)
  cidprod_block              = var.manage_public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      "Name"   = format("manage-sn-%s-public-%s", var.game_code, var.azs[count.index])
      "subnet" = "manage-sn-public"
    },
  )
}

# private subnet
resource "aws_subnet" "prod-sn-private" {
  count = local.create_prod_vpc ? length(var.prod_private_subnets) : 0

  # count = length(var.prod_private_subnets)

  vpc_id            = aws_vpc.prod-vpc[0].id
  cidprod_block        = var.prod_private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      "Name"                            = format("prod-sn-%s-private-%s", var.game_code, var.azs[count.index])
      "kubernetes.io/cluster/${cluster_id}"   = "shared"
      "karpenter.sh/discovery"          = ${cluster_id}
      "kubernetes.io/role/internal-elb" = "1"
      "subnet"                          = "prod-sn-private"
    },
  )
}

# database subnet

resource "aws_db_subnet_group" "prod-sn-db" {
  count = local.create_prod_vpc && length(var.prod_private_subnets) > 0 ? 1 : 0

  name        = "prod-sn-db-${var.game_code}"
  description = "Database subnet group for ${var.game_code}-terraform"
  subnet_ids  = aws_subnet.prod-sn-private.*.id

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-sn-%s-rds", var.game_code)
    },
  )
}

resource "aws_db_subnet_group" "dev-sn-db" {
  count       = local.create_dev_vpc && length(var.dev_public_subnets) > 0 ? 1 : 0
  provider    = aws.dev
  name        = "dev-sn-db-${var.game_code}"
  description = "Database subnet group for ${var.game_code}-terraform"
  subnet_ids  = aws_subnet.dev-sn-public.*.id

  tags = merge(
    var.tags,
    {
      "Name" = format("dev-sn-%s-rds", var.game_code)
    },
  )
}

# # elasticache subnet

resource "aws_elasticache_subnet_group" "prod-sn-redis" {
  count = local.create_prod_vpc && length(var.prod_private_subnets) > 0 ? 1 : 0

  name        = "prod-sn-redis-${var.game_code}"
  description = "ElastiCache subnet group for ${var.game_code} by terraform"
  subnet_ids  = aws_subnet.prod-sn-private.*.id
}

resource "aws_elasticache_subnet_group" "dev-sn-redis" {
  count       = local.create_dev_vpc && length(var.dev_public_subnets) > 0 ? 1 : 0
  provider    = aws.dev
  name        = "dev-sn-redis-${var.game_code}"
  description = "ElastiCache subnet group for ${var.game_code} by terraform"
  subnet_ids  = aws_subnet.dev-sn-public.*.id
}

# EIP for NAT gateway
resource "aws_eip" "nat" {
  count = local.create_prod_vpc ? length(var.azs) : 0

  # count = length(var.azs)

  vpc = true

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-%s-ngw-eip-%s", var.game_code, var.azs[count.index])
    },
  )
}

# NAT gateway
resource "aws_nat_gateway" "prod-ngw" {
  count = local.create_prod_vpc ? length(var.azs) : 0

  # count = length(var.azs)

  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.prod-sn-public.*.id[count.index]
  #allocation_id = aws_eip.nat.id
  #subnet_id     = aws_subnet.prod-sn-public[0].id

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-%s-ngw-%s", var.game_code, var.azs[count.index])
    },
  )
}

# default network ACL
resource "aws_default_network_acl" "prod_default" {
  count = local.create_prod_vpc ? 1 : 0

  default_network_acl_id = aws_vpc.prod-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }
  subnet_ids = null

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_network_acl" "dev_default" {
  count                  = local.create_dev_vpc ? 1 : 0
  provider               = aws.dev
  default_network_acl_id = aws_vpc.dev-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }

  subnet_ids = null

  tags = merge(
    var.tags,
    {
      "Name" = format("dev-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_network_acl" "manage_default" {
  count = local.create_manage_vpc ? 1 : 0

  default_network_acl_id = aws_vpc.manage-vpc[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidprod_block = "0.0.0.0/0"
    fromanage_port  = 0
    to_port    = 0
  }

  # subnet_ids = aws_subnet.manage-sn-public.*.id
  subnet_ids = null


  tags = merge(
    var.tags,
    {
      "Name" = format("manage-%s-default", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

# public route table
resource "aws_default_route_table" "dev-rtb-public" {
  count                  = local.create_dev_vpc ? 1 : 0
  provider               = aws.dev
  default_route_table_id = aws_vpc.dev-vpc[0].default_route_table_id

  route {
    cidprod_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw[0].id
  }

  # route {
  #   cidprod_block                = aws_vpc.manage-vpc.cidprod_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.manage-to-q.id
  # }

  tags = merge(
    var.tags,
    {
      "Name" = format("dev-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_default_route_table" "manage-rtb-public" {
  count = local.create_manage_vpc ? 1 : 0

  default_route_table_id = aws_vpc.manage-vpc[0].default_route_table_id

  route {
    cidprod_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.manage_igw[0].id
  }

  # route {
  #   cidprod_block                = aws_vpc.dev-vpc.cidprod_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.manage-to-q.id
  # }

  # route {
  #   cidprod_block                = aws_vpc.prod-vpc.cidprod_block
  #   vpc_peering_connection_id = aws_vpc_peering_connection.manage-to-r.id
  # }

  tags = merge(
    var.tags,
    {
      "Name" = format("manage-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_default_route_table" "prod-rtb-public" {
  count = local.create_prod_vpc ? 1 : 0

  default_route_table_id = aws_vpc.prod-vpc[0].default_route_table_id

  route {
    cidprod_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw[0].id
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-rtb-%s-public", var.game_code)
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}

# private route table
resource "aws_route_table" "prod-rtb-private" {
  count = local.create_prod_vpc ? length(var.azs) : 0

  vpc_id = aws_vpc.prod-vpc[0].id

  route {
    cidprod_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod-ngw.*.id[count.index]
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("prod-rtb-%s-private-%s", var.game_code, var.azs[count.index])
    }
  )
  lifecycle {
    ignore_changes = [route]
  }
}


# route table association
resource "aws_route_table_association" "prod-rtb-public" {
  count = local.create_prod_vpc ? length(var.prod_public_subnets) : 0

  subnet_id      = aws_subnet.prod-sn-public[count.index].id
  route_table_id = aws_default_route_table.prod-rtb-public[0].id
}

resource "aws_route_table_association" "prod-rtb-private" {
  count = local.create_prod_vpc ? length(var.prod_private_subnets) : 0

  subnet_id      = aws_subnet.prod-sn-private.*.id[count.index]
  route_table_id = aws_route_table.prod-rtb-private.*.id[count.index]
}


resource "aws_route_table_association" "dev-rtb-public" {
  count          = local.create_dev_vpc ? length(var.dev_public_subnets) : 0
  provider       = aws.dev
  subnet_id      = aws_subnet.dev-sn-public[0].id
  route_table_id = aws_vpc.dev-vpc[0].default_route_table_id
}

resource "aws_route_table_association" "manage-rtb-public" {
  count = local.create_manage_vpc ? length(var.manage_public_subnets) : 0

  subnet_id      = aws_subnet.manage-sn-public[count.index].id
  route_table_id = aws_vpc.manage-vpc[0].default_route_table_id
}

#Peering
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "dev" {
  count         = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider      = aws.prod
  vpc_id        = try(aws_vpc.manage-vpc[0].id, var.manage_vpc_id)
  peeprod_vpc_id   = aws_vpc.dev-vpc[0].id
  peeprod_owneprod_id = try(local.dev_owneprod_id, data.aws_calleprod_identity.current.account_id)
  peeprod_region   = local.dev_region
  auto_accept   = false

  tags = {
    Name = format("peering-(%s-%s-${local.dev_region})-(%s-%s-${local.manage_region})", local.dev_env, local.dev_game_code, local.manage_env, local.manage_game_code)


  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "dev" {
  count                     = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider                  = aws.dev
  vpc_peering_connection_id = aws_vpc_peering_connection.dev[0].id
  auto_accept               = true

  tags = {
    Name = format("peering-(%s-%s-${local.dev_region})-(%s-%s-${local.manage_region})", local.dev_env, local.dev_game_code, local.manage_env, local.manage_game_code)
  }
}

resource "aws_vpc_peering_connection" "prod" {
  count       = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 1 : 0
  provider    = aws.prod
  vpc_id      = try(aws_vpc.manage-vpc[0].id, var.manage_vpc_id)
  peeprod_vpc_id = aws_vpc.prod-vpc[0].id
  peeprod_region = local.prod_region
  auto_accept = false

  tags = {
    Name = format("peering-(%s-%s-${local.prod_region})-(%s-%s-${local.manage_region})", local.prod_env, local.prod_game_code, local.manage_env, local.manage_game_code)
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "prod" {
  count                     = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 1 : 0
  provider                  = aws.prod
  vpc_peering_connection_id = aws_vpc_peering_connection.prod[0].id
  auto_accept               = true

  tags = {
    Name = format("peering-(%s-%s-${local.prod_region})-(%s-%s-${local.manage_region})", local.prod_env, local.prod_game_code, local.manage_env, local.manage_game_code)
  }
}

resource "aws_route" "route_manage_q" {
  count                     = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider                  = aws.prod
  route_table_id            = try(aws_default_route_table.manage-rtb-public[count.index].id, var.manage_rtb_id)
  destination_cidprod_block    = aws_vpc.dev-vpc[0].cidprod_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dev[0].id
}

resource "aws_route" "route_dev_m" {
  count                     = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider                  = aws.dev
  route_table_id            = aws_default_route_table.dev-rtb-public[count.index].id
  destination_cidprod_block    = try(aws_vpc.manage-vpc[0].cidprod_block, var.manage_cidr)
  vpc_peering_connection_id = aws_vpc_peering_connection.dev[0].id
}

resource "aws_route" "route_manage_r" {
  count                     = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 1 : 0
  provider                  = aws.prod
  route_table_id            = try(aws_default_route_table.manage-rtb-public[count.index].id, var.manage_rtb_id)
  destination_cidprod_block    = aws_vpc.prod-vpc[0].cidprod_block
  vpc_peering_connection_id = aws_vpc_peering_connection.prod[0].id
}

resource "aws_route" "route_prod_m" {
  count                     = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 3 : 0
  provider                  = aws.prod
  route_table_id            = concat(aws_default_route_table.prod-rtb-public[*].id, aws_route_table.prod-rtb-private[*].id)[count.index]
  destination_cidprod_block    = try(aws_vpc.manage-vpc[0].cidprod_block, var.manage_cidr)
  vpc_peering_connection_id = aws_vpc_peering_connection.prod[0].id
}


resource "aws_vpc_peering_connection_options" "dev_m" {
  count                     = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider                  = aws.prod
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.dev[0].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "manage_q" {
  count                     = local.create_manage_vpc && local.create_dev_vpc ? 1 : 0
  provider                  = aws.dev
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.dev[0].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "manage_r" {
  count                     = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 1 : 0
  provider                  = aws.prod
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.prod[0].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "prod_m" {
  count                     = local.create_manage_to_prod_peer || local.create_manage_vpc && local.create_prod_vpc ? 1 : 0
  provider                  = aws.prod
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.prod[0].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
