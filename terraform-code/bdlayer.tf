
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "wordpresscluster"
  availability_zones = ["us-west-1a", "us-west-1b"]
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.04.2"
  master_username    = "wp_user1"
  master_password    = "wpadmin1"
  database_name      = "Wordpress"

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

