resource "aws_db_instance" "InstanceDB" {
    instance_class = "db.t4g.small"
    engine = "aurora-mysql"
    db_name = "wordpressDB"
    
  
}