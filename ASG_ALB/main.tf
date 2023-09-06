locals {
  vpc = {
    cidr = "192.168.0.0/16"
    public_subnets = {
      # cidrs = []
      cidrs = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
      names = ["public-subnet-1", "public-subnet-2", "public-subnet-3"]
    }
    private_subnets = {
      cidrs = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
      names = ["private-subnet-1", "private-subnet-2", "private-subnet-3"]
    }
  }
}

data "aws_availability_zones" "singapore" {
  state = "available"
}

resource "aws_vpc" "non_prod" {
  cidr_block           = local.vpc.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "non-prod-vpc"
  }
}

resource "aws_internet_gateway" "non_prod_igw" {
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = "non-prod-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(local.vpc.public_subnets.cidrs) > 0 ? length(local.vpc.public_subnets.cidrs) : 0
  vpc_id                  = aws_vpc.non_prod.id
  availability_zone       = data.aws_availability_zones.singapore.names[count.index]
  cidr_block              = local.vpc.public_subnets.cidrs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = local.vpc.public_subnets.names[count.index]
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.non_prod_igw.id
}

resource "aws_route_table_association" "route_table_assoc_public" {
  count          = length(aws_subnet.public_subnets) > 0 ? length(aws_subnet.public_subnets) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.vpc.private_subnets.cidrs) > 0 ? length(local.vpc.private_subnets.cidrs) : 0
  vpc_id            = aws_vpc.non_prod.id
  availability_zone = data.aws_availability_zones.singapore.names[count.index]
  cidr_block        = local.vpc.private_subnets.cidrs[count.index]
  tags = {
    Name = local.vpc.private_subnets.names[count.index]
  }
}

# resource "aws_eip" "nat_gateway_eip" {
#   domain = "vpc"
#   tags = {
#     Name = "nat-gateway-eip"
#   }
# }

# resource "aws_nat_gateway" "non_prod_nat" {
#   allocation_id     = aws_eip.nat_gateway_eip.allocation_id
#   connectivity_type = "public"
#   subnet_id         = aws_subnet.public_subnets[0].id
#   tags = {
#     Name = "non-prod-NAT-gateway"
#   }
# }

resource "aws_route_table" "private_route_tables" {
  count  = length(aws_subnet.private_subnets) > 0 ? length(aws_subnet.private_subnets) : 0
  vpc_id = aws_vpc.non_prod.id
  tags = {
    Name = local.vpc.private_subnets.names[count.index]
  }
}

# resource "aws_route" "nat_routes" {
#   count = length(aws_route_table.private_route_tables) > 0 ? length(aws_route_table.private_route_tables) : 0
#   route_table_id         = aws_route_table.private_route_tables[count.index].id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_nat_gateway.non_prod_nat.id
# }

resource "aws_route_table_association" "route_table_assoc_private_subnets" {
  count          = length(aws_subnet.private_subnets) > 0 ? length(aws_subnet.private_subnets) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}



resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic from internet"
  vpc_id      = aws_vpc.non_prod.id

  ingress {
    description      = "HTTP from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "ssh from internet, Allow HTTP inbound traffic from application load balancer"
  vpc_id      = aws_vpc.non_prod.id

  ingress {
    description      = "HTTP from alb-sg"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = [aws_security_group.alb_sg.id]
  }

  #   ingress {
  #     description      = "ssh from internet"
  #     from_port        = 22
  #     to_port          = 22
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = []
  #   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

data "aws_ami" "my_alb_app" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["ami-myalbapp"]
  }
}


resource "aws_launch_template" "my_asg_lt" {
  name                   = "My-ASG-LT"
  description            = "Launch Template for ASG load test"
  image_id               = data.aws_ami.my_alb_app.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = {
    Name = "My-ASG-LT"
  }
}

resource "aws_alb" "my_alb" {
  load_balancer_type = "application"
  name               = "My-ALB"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  tags = {
    Name = "My-ALB"
  }
}

resource "aws_alb_target_group" "my_tg" {
  name     = "My-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.non_prod.id
  tags = {
    Name = "My-TG"
  }
  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_alb_listener" "my_alb_listener" {
  load_balancer_arn = aws_alb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.my_tg.arn
    type             = "forward"
  }
}


resource "aws_autoscaling_group" "my_asg" {
  name                = "My-ASG"
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [aws_alb_target_group.my_tg.arn]
  launch_template {
    id      = aws_launch_template.my_asg_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "MyASG-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_resouce" {
  name = "cpu_resource"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}