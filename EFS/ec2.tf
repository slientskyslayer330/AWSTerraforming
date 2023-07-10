data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "sg_application_group" {
  name        = "applicationSecurityGroup"
  description = "Allow ssh access from internet to applications"
  vpc_id      = aws_vpc.helloCloudTesting.id

  ingress {
    description      = "ssh acceess allow to ec2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "sg_applications"
  }
}

data "template_file" "efs_userdata" {
  template = file("${path.module}/scripts/efs_userdata.sh.tpl")

  vars = {
    efs_dns_name = aws_efs_file_system.efs-helloCloudTesting.dns_name
  }
}

resource "aws_instance" "application" {
  count                       = length(var.application_instance_azs)
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.application_instance_size
  key_name                    = aws_key_pair.application_efs_key_pair.id
  vpc_security_group_ids      = [aws_security_group.sg_application_group.id]
  subnet_id                   = aws_subnet.public_subnets[var.application_instance_azs[count.index]].id
  associate_public_ip_address = true
  user_data = data.template_file.efs_userdata.rendered
  tags = {
    Name = "${aws_subnet.public_subnets[var.application_instance_azs[count.index]].tags.Name}-ec2-instance"
  }
  
}
