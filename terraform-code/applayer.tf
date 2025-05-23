resource "aws_lb_target_group" "TargetGroup" {
  name        = "EcsTargetGroup"
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  target_health_state {
    enable_unhealthy_connection_termination = false
  }
}

resource "aws_security_group" "appSg" {
  name        = "appSG"
  description = "Security group do ECS"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "appIngress" {
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.appSg.id
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.ALBSG.id
}

resource "aws_vpc_security_group_egress_rule" "appEgress" {
  ip_protocol       = -1
  security_group_id = aws_security_group.appSg.id
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
}



resource "aws_ecs_cluster" "EcsCluster" {
  name = "TCC-Cluster"

}

resource "aws_iam_role" "ecsExecution" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ecs-tasks.amazonaws.com
        }
      }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.ecsExecution.name
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecsExecution.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_core_polic" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ecsExecution.name
}


resource "aws_ecs_task_definition" "Task" {
  execution_role_arn       = aws_iam_role.ecsExecution.arn
  task_role_arn            = aws_iam_role.ecsExecution.arn
  requires_compatibilities = ["FARGATE"]
  family                   = "service"
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name   = "WordPress"
      image  = "public.ecr.aws/bitnami/wordpress:latest"
      cpu    = 512
      memory = 1024
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "wordpress_database_host"
          value = "${aws_rds_cluster.rds_cluster.endpoint}"
        },
        {
          name  = "WORDPRESS_DATABASE_PORT_NUMBER"
          value = "3306"
        },
        {
          name  = "WORDPRESS_DATABASE_NAME"
          value = "wordpress"
        },
        {
          name  = "WORDPRESS_DATABASE_USER"
          value = "wp_user1"
        },
        {
          name  = "WORDPRESS_DATABASE_PASSWORD"
          value = "wpadmin1"
        },
        {
          name  = "BITNAMI_DEBUG"
          value = "true"
        },
        {
          name  = "APACHE_LOG_LEVEL"
          value = "debug"
        },
        {
          name  = "APACHE_HTTP_ADDRESS"
          value = "0.0.0.0"
        },
      ]
      log_Configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.logGroup.name}"
          awslogs-region        = "us-west-1"
          awslogs-stream-prefix = "debug"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "logGroup" {
  name = "/ecs/wordpress"
}


resource "aws_ecs_service" "EcsService" {
  name            = "WordPress"
  cluster         = aws_ecs_cluster.EcsCluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.Task.arn

  network_configuration {
    subnets          = [aws_subnet.AppSubnetA.id, aws_subnet.AppSubnetB.id]
    security_groups  = [aws_security_group.appSg.id]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = "WordPress"
    container_port   = 8080
    target_group_arn = aws_lb_target_group.TargetGroup.arn
  }


  depends_on = [
    aws_lb.LoadBalancer,
    aws_lb_listener.Listener,
    aws_lb_target_group.TargetGroup,
    aws_rds_cluster.rds_cluster,
    aws_rds_cluster_instance.instanceA,
    aws_rds_cluster_instance.instanceB
  ]

}