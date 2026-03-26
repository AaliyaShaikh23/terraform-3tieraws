resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL access only from app tier"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from app SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-sg"
  })
}

resource "aws_db_instance" "this" {
  identifier                 = "${var.project_name}-mysql"
  allocated_storage          = 20
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = var.db_instance_class
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.db.id]
  publicly_accessible        = false
  multi_az                   = false
  skip_final_snapshot        = true
  backup_retention_period    = 0
  deletion_protection        = false
  storage_encrypted          = true
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-mysql"
  })
}
