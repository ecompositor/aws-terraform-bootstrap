# VPCs are confusing. The hierarchy of ACL is:
# VPC -> Security group
#
# I believe the process of ingress is:
# public client -> VPC -> VPC route table -> igw -> instance
#
# And egress is:
# instance -> VPC route table -> igw or nat -> public address

# App VPC. Does not allow local access with CIDR block configuration.
# An AWS help desk recommended way to enable access to the bastion host from your local machine is to go to
# https://us-west-1.console.aws.amazon.com/vpc/home?region=us-west-1#vpcs and add a CIDR block containing your IP
# address to the VPC settings.
resource "aws_vpc" "hello_world" {
  tags {
    Project = "hello-world"
    Name    = "hello-world VPC"
  }

  # https://serverfault.com/questions/630022/what-is-the-recommended-cidr-when-creating-vpc-on-aws
  # "...there is no harm in starting with a small prefix such as /16 because you can always create subnets."
  cidr_block = "10.0.0.0/16"

  # enabled by default, but just to be sure
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_db_subnet_group" "hello_world_db_subnet" {
  name        = "hello_world_db_subnet"
  description = "db subnet group"
  subnet_ids  = ["${aws_subnet.hello_world_private_region_1_az_1.id}", "${aws_subnet.hello_world_private_region_1_az_2.id}"]

  tags {
    Project = "hello-world"
    Name    = "DB subnet group"
  }
}

# https://serverfault.com/questions/630022/what-is-the-recommended-cidr-when-creating-vpc-on-aws
# ...For smaller networks, use a 24-bit mask in different regions
# Private
resource "aws_subnet" "hello_world_private_region_1_az_1" {
  availability_zone = "${var.region_1_az_1}"

  tags {
    Project = "hello-world"
    Name    = "private ${var.region_1_az_1} subnet"
  }

  cidr_block = "10.0.0.0/24"
  vpc_id     = "${aws_vpc.hello_world.id}"
}

resource "aws_subnet" "hello_world_private_region_1_az_2" {
  availability_zone = "${var.region_1_az_2}"

  tags {
    Name    = "private ${var.region_1_az_2} subnet"
    Project = "hello-world"
  }

  cidr_block = "10.0.1.0/24"
  vpc_id     = "${aws_vpc.hello_world.id}"
}

# Public
resource "aws_subnet" "hello_world_public_region_1_az_1" {
  availability_zone = "${var.region_1_az_1}"

  tags {
    Project = "hello-world"
    Name    = "public ${var.region_1_az_1} subnet"
  }

  cidr_block = "10.0.2.0/24"
  vpc_id     = "${aws_vpc.hello_world.id}"
}

resource "aws_subnet" "hello_world_public_region_1_az_2" {
  availability_zone = "${var.region_1_az_2}"

  tags {
    Project = "hello-world"
    Name    = "public ${var.region_1_az_2} subnet"
  }

  cidr_block = "10.0.3.0/24"
  vpc_id     = "${aws_vpc.hello_world.id}"
}

output "default_vpc_id" {
  value = "${aws_vpc.hello_world.id}"
}
