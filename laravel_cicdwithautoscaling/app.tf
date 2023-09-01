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


resource "aws_alb" "laravel_alb" {
  load_balancer_type = "application"
  name               = "laravel-alb"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_alb_target_group" "laravel_tg" {
  name     = "LaravelTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.non_prod.id
  tags = {
    Name = "Laravel-TG"
  }
  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_alb_listener" "laravel_alb_listener" {
  load_balancer_arn = aws_alb.laravel_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.laravel_tg.arn
    type             = "forward"
  }
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    # values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"] /ubuntu
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "laravel-test-key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.ec2_key_pair.key_name}.pem"
  content         = tls_private_key.key_pair.private_key_pem
  file_permission = "0400"
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow HTTP inbound traffic from application load balancer"
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

data "template_file" "userdata" {
  template = file("${path.module}/scripts/setup.sh.tpl")
  vars = {
    s3_bucket = aws_s3_bucket.laravel_cicd_artifacts.bucket
  }
}


resource "aws_launch_template" "laravel_lt" {
  name                   = "LaravelLT"
  description            = "Launch Template for Laravel CICD"
  image_id               = data.aws_ami.amazon_linux2.image_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile {
    name = data.aws_iam_role.gitlab_ci_ec2_role.name
  }
  user_data = base64encode(data.template_file.userdata.rendered)
  tags = {
    Name = "LaravelLT"
  }
}

resource "aws_autoscaling_group" "laravel_asg" {
  name                = "LaravelASG"
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  target_group_arns   = [aws_alb_target_group.laravel_tg.arn]
  launch_template {
    id      = aws_launch_template.laravel_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "LaravelASG-instance"
    propagate_at_launch = true
  }
}

# resource "aws_alb_target_group_attachment" "laravel_alb_tg_attachment" {
#   target_group_arn = aws_alb_target_group.laravel_tg.arn
#   target_id        = aws_autoscaling_group.laravel_asg.
#   port             = 80
# }