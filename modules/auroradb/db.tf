data "aws_vpc" "vpc" {
  id = var.vpc_id
}


resource "aws_security_group" "sg-rds" {
  name        = "${var.account}-sg-rds-aurora-${var.env}-${var.app}"
  description = "Allow MYSQL inbound traffic"
  vpc_id      = var.vpc_id


  ingress {
    description     = "ecs-to-rds"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ecs_sg]
  }

  dynamic "ingress" {
    for_each = var.grant_dev_db_access ? [1] : []
    content {
      description = "PA VPN External IP"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = var.whitelist_ips
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.account}-sg-rds-aurora-${var.env}-${var.app}"
    Environment = var.env
    System      = var.app
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "credentials" {
  name                    = "${var.account}-secret-${var.env}-rds-aurora-mysql-${var.app}-admin-password"
  recovery_window_in_days = 0
  tags = {
    Name        = "${var.account}-secret-${var.env}-rds-aurora-mysql-${var.app}-admin-password"
    Environment = var.env
    System      = var.app
  }
}

resource "aws_secretsmanager_secret_version" "credentials" {
  secret_id     = aws_secretsmanager_secret.credentials.id
  secret_string = <<EOF
   {
    "password": "${random_password.password.result}"
   }
EOF
}

## AUROARA RDS CLUSTER

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "${var.account}-rds-aurora-${var.env}-${var.app}-pg"
  family      = "aurora-mysql8.0"
  description = "RDS parameter group"

  parameter {
    name         = "binlog_format"
    value        = "row"
    apply_method = "pending-reboot"
  }
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${var.account}-rds-aurora-${var.env}-${var.app}-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = var.engine_version
  engine_mode                     = "provisioned"
  availability_zones              = var.az_zones
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = random_password.password.result
  backup_retention_period         = var.backup_retention_period
  preferred_maintenance_window    = var.maintenance_window
  preferred_backup_window         = "23:00-00:00"
  storage_encrypted               = true
  skip_final_snapshot             = var.skip_final_snapshot
  db_subnet_group_name            = var.subnet_group
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.name
  enabled_cloudwatch_logs_exports = var.log_types
  vpc_security_group_ids          = [aws_security_group.sg-rds.id]

  serverlessv2_scaling_configuration {
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
  }

  tags = merge(
    {
      Name             = "${var.account}-rds-aurora-${var.env}-${var.app}"
      Environment      = var.env
      System           = var.app
      aws-backup-daily = true
    },
    var.add_scheduler_tag ? { "instance-scheduler" = "rds-default" } : {},
    var.env == "prod" ? { "aws-backup-daily" = "true" } : {},
    var.env == "prod" ? { "aws-backup-weekly" = "true" } : {},
  )
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count               = var.instance_count
  identifier          = "${var.account}-rds-aurora-${var.env}-${var.app}-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.rds_cluster.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.rds_cluster.engine
  engine_version      = aws_rds_cluster.rds_cluster.engine_version
  publicly_accessible = var.publicly_accessible

  tags = {
    Name        = "${var.account}-rds-aurora-${var.env}-${var.app}-${count.index}"
    Environment = var.env
    System      = var.app
  }
}

output "db_instances" {
  value = aws_rds_cluster_instance.cluster_instances.*.id

}

#SQL USER PASSWORD

resource "random_password" "sql_user_password" {
  count            = var.env == "dev" || var.env == "test" ? 0 : 1
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "sql_user_credentials" {
  count                   = var.env == "dev" || var.env == "test" ? 0 : 1
  name                    = "${var.account}-secret-${var.env}-rds-aurora-mysql-${var.app}-biuser-password"
  recovery_window_in_days = 0
  tags = {
    Name        = "${var.account}-secret-${var.env}-rds-aurora-mysql-${var.app}-biuser-password"
    Environment = var.env
    System      = var.app
  }
}

resource "aws_secretsmanager_secret_version" "sql_user_credentials" {
  count         = var.env == "dev" || var.env == "test" ? 0 : 1
  secret_id     = aws_secretsmanager_secret.sql_user_credentials[0].id
  secret_string = <<EOF
   {
    "password": "${random_password.sql_user_password[0].result}"
   }
EOF
}