# resource "aws_db_subnet_group" "non_prod_db_subnet" {
#   name       = "non-prod"
#   subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

#   tags = {
#     Name = "non-prod"
#   }
# }

# resource "aws_security_group" "rds" {
#   name   = "non-prod-rds-sg"
#   vpc_id = aws_vpc.non_prod.id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = []
#     security_groups = [ aws_security_group.app_sg.id ]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "non-prod-rds-sg"
#   }
# }

# resource "random_password" "database" {
#   length           = 12
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# resource "aws_db_instance" "non_prod_mysql" {
#   identifier             = "non-prod-mysql"
#   instance_class         = "db.t3.micro"
#   allocated_storage      = 5
#   engine                 = "mysql"
#   engine_version         = "8.0"
#   username               = "admin"
#   password               = random_password.database.result
#   db_subnet_group_name   = aws_db_subnet_group.non_prod_db_subnet.name
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   publicly_accessible    = true
#   skip_final_snapshot    = true
# }