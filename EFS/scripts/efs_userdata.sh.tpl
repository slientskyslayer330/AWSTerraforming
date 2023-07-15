#!/bin/bash
yum update -y
yum install -y amazon-efs-utils
mkdir -p ${mount_point}
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns_name}:/  /mnt/efs/fs1
echo "${efs_dns_name}:/ ${mount_point} nfs defaults,_netdev 0 0" >> /etc/fstab