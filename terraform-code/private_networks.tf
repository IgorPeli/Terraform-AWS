resource "aws_route_table" "RouterToNatA" {
  vpc_id = aws_vpc.main.id
  #Criando-se as regras  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natA.id
  }
}
 
resource "aws_route_table_association" "PrivateAssociationA" {
  route_table_id = aws_route_table.RouterToNatA.id
  subnet_id      = aws_subnet.AppSubnetA.id

}


resource "aws_route_table" "RouterToNatB" {
  vpc_id = aws_vpc.main.id
  #Criando-se as regras  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natB.id
  }
}

resource "aws_route_table_association" "PrivateAssociationB" {
  route_table_id = aws_route_table.RouterToNatB.id
  subnet_id      = aws_subnet.AppSubnetB.id

}