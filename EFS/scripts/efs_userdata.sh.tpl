#!/bin/bash
yum install -y amazon-efs-utils
mkdir -p /mnt/efs/fs1
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/  /mnt/efs/fs1
echo "${efs_dns_name}:/ /mnt/efs/fs1 nfs defaults,_netdev 0 0" >> /etc/fstab
echo "user data run completed" >> /home/ec2-user/hello.txt