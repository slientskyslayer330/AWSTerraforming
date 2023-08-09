module "testing_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "testing"
  cidr = "10.0.0.0/16"

  azs                     = ["ap-southeast-1a"]
  private_subnets         = ["10.0.1.0/24"]
  public_subnets          = ["10.0.2.0/24"]
  map_public_ip_on_launch = false

  tags = {
    Terraform = "true"
  }
}

module "app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1.0"

  vpc_id              = module.testing_vpc.vpc_id
  name                = "application_server_sg"
  description         = "SSH ingress allow, all egress allow"
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.ec2_key_pair.key_name}.pem"
  content         = tls_private_key.key_pair.private_key_pem
  file_permission = "0400"
}

module "app_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.app_instance_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.app_instance_type
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids      = [module.app_sg.security_group_id]
  subnet_id                   = module.testing_vpc.public_subnets[0]
  associate_public_ip_address = true
  availability_zone           = module.testing_vpc.azs[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "database_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1.0"

  vpc_id      = module.testing_vpc.vpc_id
  name        = "database_sg"
  description = "allow database access from app-sg"
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}

resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_instance_name

  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_type
  allocated_storage    = 5
  skip_final_snapshot  = true       #for easier replacement. not for prod
  family               = "mysql8.0" #parameter group
  major_engine_version = "8.0"      #options group

  availability_zone      = module.testing_vpc.azs[0]
  subnet_ids             = module.testing_vpc.private_subnets
  vpc_security_group_ids = [module.database_sg.security_group_id]

  db_name  = "test"
  username = "admin"
  password = random_password.db.result
  port     = "3306"

  tags = {
    Environment = "dev"
  }
}