#Criando-se a tabela
resource "aws_route_table" "RouterToIGW" {
  vpc_id = aws_vpc.main.id
  #Criando-se as regras  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "PublicAssociationA" {
  subnet_id      = aws_subnet.AppSubnetA
  route_table_id = aws_route_table.RouterToIGW

}

resource "aws_route_table_association" "PublicAssociationB" {
  subnet_id      = aws_subnet.AppSubnetB
  route_table_id = aws_route_table.RouterToIGW

}
