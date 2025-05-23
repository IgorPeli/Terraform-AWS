
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier     = "wordpresscluster"
  availability_zones     = ["us-west-1a", "us-west-1b"]
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.04.2"
  master_username        = "wp_user1"
  master_password        = "wpadmin1"
  database_name          = "Wordpress"
  vpc_security_group_ids = [aws_security_group.allow_aurora.id] #Este cluster Aurora só pode ser acessado de acordo com as regras do grupo de segurança allow_aurora

}

resource "aws_rds_cluster_instance" "instanceA" {
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
  instance_class     = "db.t4g.small"
  cluster_identifier = aws_rds_cluster.rds_cluster.id
  availability_zone  = "us-west-1a"

}

resource "aws_rds_cluster_instance" "instanceB" {
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
  instance_class     = "db.t4g.small"
  cluster_identifier = aws_rds_cluster.rds_cluster.id
  availability_zone  = "us-west-1b"

}

resource "aws_security_group" "allow_aurora" {
  name        = "AuroraSG"
  description = "Security Group for the BD Instances"
  vpc_id      = aws_vpc.main.id

}

resource "aws_vpc_security_group_ingress_rule" "IngressDB" {
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.EcsSG.id
  security_group_id            = aws_security_group.allow_aurora.id
  from_port                    = 3306
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "EgressDB" {
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  security_group_id = aws_security_group.allow_aurora.id

}

