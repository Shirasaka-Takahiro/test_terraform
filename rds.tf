##Subnet Group
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.general_config["project"]}-${var.general_config["environment"]}-subnet-group"
  subnet_ids = [aws_subnet.private-subnets["private-1a"].id, aws_subnet.private-subnets["private-1c"].id]

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-subnet-group"
  }
}

##Parameter Group
resource "aws_db_parameter_group" "mysql_parameter_group" {
  name   = "${var.general_config["project"]}-${var.general_config["environment"]}-parameter-group"
  family = "mysql8.0"

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "general_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_output"
    value        = "TABLE"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }

}

##Option Group
resource "aws_db_option_group" "mysql_option_group" {
  name                 = "${var.general_config["project"]}-${var.general_config["environment"]}-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

##DB Instance
resource "aws_db_instance" "mysql_db_instance" {
  engine                              = "mysql"
  engine_version                      = "8.0.20"
  license_model                       = "general-public-license"
  identifier                          = "${var.general_config["project"]}-${var.general_config["environment"]}-db"
  username                            = var.username
  password                            = var.password
  instance_class                      = var.instance_class
  storage_type                        = var.storage_type
  allocated_storage                   = var.allocated_storage
  multi_az                            = var.multi_az
  db_subnet_group_name                = aws_db_subnet_group.mysql_subnet_group.name
  publicly_accessible                 = false
  vpc_security_group_ids              = [aws_security_group.rds.id]
  port                                = 3306
  iam_database_authentication_enabled = false
  name                                = "${var.general_config["project"]}-${var.general_config["environment"]}-db"
  parameter_group_name                = aws_db_parameter_group.mysql_parameter_group.name
  option_group_name                   = aws_db_option_group.mysql_option_group.name
  backup_retention_period             = 7
  backup_window                       = "19:00-20:00"
  copy_tags_to_snapshot               = true
  storage_encrypted                   = true
  performance_insights_enabled        = false
  maintenance_window                  = "Sat:20:00-Sat:21:00"
  deletion_protection                 = false
  skip_final_snapshot                 = true
  apply_immediately                   = false

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-db"
  }
}

