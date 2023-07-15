resource "aws_efs_file_system" "efs_testing" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  encrypted        = false
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  tags = {
    "type" = "efs"
  }
}

resource "aws_security_group" "sg_EFS" {
  name        = "efsSecurityGroup"
  description = "Allow NFS access from public subnets to efs "
  vpc_id      = aws_vpc.testing.id

  ingress {
    description      = "NFS acceess allow to efs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_application_group.id]
    cidr_blocks      = []
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.sg_application_group.id]
    cidr_blocks      = []
    ipv6_cidr_blocks = []
  }

  tags = {
    Name = "sg_efs"
  }
}


resource "aws_efs_mount_target" "efs_mt_public_testing" {
  file_system_id  = aws_efs_file_system.efs_testing.id
  for_each        = var.subnets.public.cidrs
  subnet_id       = aws_subnet.public_subnets[each.key].id
  security_groups = [aws_security_group.sg_EFS.id]
}

