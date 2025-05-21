resource "aws_vpc" "main" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-TCC"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "PublicSubnetA" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  availability_zone                              = data.aws_availability_zones.available.names[0]
  cidr_block                                     = "10.16.0.0/20"

}

resource "aws_subnet" "PublicSubnetB" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  availability_zone                              = data.aws_availability_zones.available.names[1]
  cidr_block                                     = "10.16.16.0/20"

}

resource "aws_subnet" "AppSubnetA" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  availability_zone                              = data.aws_availability_zones.available.names[0]
  cidr_block                                     = "10.16.32.0/20"
}

resource "aws_subnet" "AppSubnetB" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  availability_zone                              = data.aws_availability_zones.available.names[1]
  cidr_block                                     = "10.16.48.0/20"
}

resource "aws_subnet" "DBSubnetA" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  availability_zone                              = data.aws_availability_zones.available.names[0]
  cidr_block                                     = "10.16.64.0/20"
}

resource "aws_subnet" "DBSubnetB" {
  vpc_id                                         = aws_vpc.main.id
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  availability_zone                              = data.aws_availability_zones.available.names[1]
  cidr_block                                     = "10.16.80.0/20"
}

