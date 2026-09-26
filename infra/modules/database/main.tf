resource "random_password" "database" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" #avoid characters which can cause issues
}

#store databse in private subnet to prevent direct access by users of the internet
resource "aws_db_subnet_group" "db-subnet" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = var.private_subnet_id

  tags = {
    Name = "${var.project_name}-db-subnet"
  }
}


#RDS instance 
resource "aws_db_instance" "db-instance" {
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  identifier     = "${var.project_name}-postgres-instance"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  storage_type          = "gp3"
  port                  = 5432


  db_name  = var.db_name
  username = var.db_username
  password = random_password.database.result

  skip_final_snapshot = true #do not preserve a final copy of database upon deletion 
  deletion_protection = false
  #backup_retention_period = 7 #retain backup of database for 7 days, important for disaster recovery

  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [var.rds_security_group_id]
  publicly_accessible    = false

  tags = {
    Name = "${var.project_name}-postgres-instance"
  }
}

#store password in aws secrets manager
resource "aws_secretsmanager_secret" "database-password" {
  name                    = "${var.project_name}/rds/postgres/credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "database-password" {
  secret_id = aws_secretsmanager_secret.database-password.id

  secret_string = "postgresql://${var.db_username}:${random_password.database.result}@${aws_db_instance.db-instance.endpoint}/${var.db_name}"
}
