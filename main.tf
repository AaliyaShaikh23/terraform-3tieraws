provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name              = var.project_name
  vpc_cidr                  = var.vpc_cidr
  azs                       = local.azs
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_db_subnet_cidrs   = var.private_db_subnet_cidrs
  tags                      = local.common_tags
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP and HTTPS from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-web-sg" })
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow web traffic only from public tier"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from public subnets"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-app-sg" })
}

module "rds" {
  source = "./modules/rds"

  project_name                = var.project_name
  subnet_ids                  = module.vpc.private_db_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  db_name                     = var.db_name
  db_username                 = var.db_username
  db_password                 = var.db_password
  db_instance_class           = var.db_instance_class
  allowed_security_group_ids  = [aws_security_group.app.id]
  tags                        = local.common_tags
}

module "app" {
  source = "./modules/ec2"

  project_name           = var.project_name
  instance_name          = "app-tier"
  subnet_id              = module.vpc.private_app_subnet_ids[0]
  instance_type          = var.instance_type
  associate_public_ip    = false
  security_group_ids     = [aws_security_group.app.id]
  key_name               = var.key_name
  user_data              = templatefile("${path.module}/templates/app_user_data.sh.tftpl", {
    db_endpoint = module.rds.db_endpoint
    db_name     = var.db_name
    db_user     = var.db_username
    db_password = var.db_password
  })
  tags                   = local.common_tags
}

module "web" {
  source = "./modules/ec2"

  project_name           = var.project_name
  instance_name          = "web-tier"
  subnet_id              = module.vpc.public_subnet_ids[0]
  instance_type          = var.instance_type
  associate_public_ip    = true
  security_group_ids     = [aws_security_group.web.id]
  key_name               = var.key_name
  user_data              = templatefile("${path.module}/templates/web_user_data.sh.tftpl", {
    app_private_ip = module.app.private_ip
  })
  tags                   = local.common_tags
}
