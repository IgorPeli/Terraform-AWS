resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "eipA" {
  domain = "vpc"
}


resource "aws_nat_gateway" "natA" {
  subnet_id     = aws_subnet.AppSubnetA.id
  allocation_id = aws_eip.eipA.id
  depends_on    = [aws_internet_gateway.IGW]
}

resource "aws_eip" "eipB" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natB" {
  subnet_id     = aws_subnet.AppSubnetB.id
  allocation_id = aws_eip.eipB.id
  depends_on    = [aws_internet_gateway.IGW]
}

