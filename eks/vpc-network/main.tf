provider "aws"  {
    region = var.region
    profile = var.profile
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
       Name = var.vpc_name
    }
}

resource "aws_internet_gateway" "igw" {
   
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_subnet" "public_subnet" {

    vpc_id = aws_vpc.vpc.id

    map_public_ip_on_launch = false

    count = length(var.public_subnet_cidr)

    cidr_block = var.public_subnet_cidr[count.index]

    availability_zone = var.azs[count.index]

    tags = merge(
       { Name = "${var.vpc_name}-${var.public_subnet_names[count.index]}" },
       var.public_subnet_tags
    )
}


resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
     count = length(var.public_subnet_cidr)
     subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
     route_table_id = aws_route_table.public_rt.id
}


resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    cidr_block = var.private_subnet_cidr[count.index]
    count = length(var.private_subnet_cidr)
    availability_zone = var.azs[count.index]
    
    tags = merge(
       { Name = "${var.vpc_name}-${var.private_subnet_names[count.index]}" },
       var.private_subnet_tags
    )
}



resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id
    count = 1

    tags = {
        Name = "${var.vpc_name}-private-rt"
    }
}

resource "aws_route_table_association" "private-association" {
    count = length(var.private_subnet_cidr)
    subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
    route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

# nat

resource "aws_eip" "eip" {
  count = var.enable_nat_gateway ? 1 : 0

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}


resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.eip[count.index].id
  subnet_id   =   aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}



resource "aws_route" "nat_gateway_route" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id

  depends_on = [aws_nat_gateway.nat]
}