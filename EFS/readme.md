# EFS + 2 EC2 without using Module

This one is my first terraform hobby project. It builds vpc with public subnets and private subnets in 3 avaliability zones (AZs) in AWS singapore region. Then it create EFS in the vpc and create mount target to public subnets. 2 EC2 instances are created in ap-southeast-1a and ap-southeast-1b AZs. EFS is mounted on /mnt/efs/fs1.

## How to use

You need to install terraform and aws-cli before to test it out.  

Define aws_access_key and aws_secret_key in auto.tfvars or where you want the repo to run.

## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 4.0   |

## Providers

| Name                                                             | Version |
| ---------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)                | 4.67.0  |
| <a name="provider_local"></a> [local](#provider\_local)          | 2.4.0   |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0   |
| <a name="provider_tls"></a> [tls](#provider\_tls)                | 4.0.4   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                           | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_efs_file_system.efs_testing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)                                 | resource    |
| [aws_efs_mount_target.efs_mt_public_testing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target)                     | resource    |
| [aws_instance.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                               | resource    |
| [aws_internet_gateway.internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                          | resource    |
| [aws_key_pair.ec2_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)                                              | resource    |
| [aws_route_table.public_sub_internet_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                              | resource    |
| [aws_route_table_association.public_sub_internet_rt_asso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_security_group.sg_EFS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                        | resource    |
| [aws_security_group.sg_application_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                          | resource    |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                               | resource    |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                | resource    |
| [aws_vpc.testing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                             | resource    |
| [local_file.ssh_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)                                                       | resource    |
| [tls_private_key.key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)                                            | resource    |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                   | data source |
| [template_file.efs_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)                                         | data source |

## Inputs

| Name                                                                                                              | Description                                | Type                                                                                                                                                                     | Default                                                                                                                                                                                                                                                                                                                                                                                         | Required |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_application_instance_azs"></a> [application\_instance\_azs](#input\_application\_instance\_azs)    | azs of application instances               | `list(string)`                                                                                                                                                           | <pre>[<br>  "ap-southeast-1a",<br>  "ap-southeast-1b"<br>]</pre>                                                                                                                                                                                                                                                                                                                                |    no    |
| <a name="input_application_instance_size"></a> [application\_instance\_size](#input\_application\_instance\_size) | instance size of application server        | `string`                                                                                                                                                                 | `"t2.micro"`                                                                                                                                                                                                                                                                                                                                                                                    |    no    |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key)                                  | Access key of AWS to access from terraform | `string`                                                                                                                                                                 | n/a                                                                                                                                                                                                                                                                                                                                                                                             |   yes    |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key)                                  | Secret key of AWS to access from terraform | `string`                                                                                                                                                                 | n/a                                                                                                                                                                                                                                                                                                                                                                                             |   yes    |
| <a name="input_subnets"></a> [subnets](#input\_subnets)                                                           | subnets ips and zones                      | <pre>map(object({<br>    cidrs = object({<br>      ap-southeast-1a = string<br>      ap-southeast-1b = string<br>      ap-southeast-1c = string<br>    })<br>  }))</pre> | <pre>{<br>  "private": {<br>    "cidrs": {<br>      "ap-southeast-1a": "10.0.128.0/20",<br>      "ap-southeast-1b": "10.0.144.0/20",<br>      "ap-southeast-1c": "10.0.160.0/20"<br>    }<br>  },<br>  "public": {<br>    "cidrs": {<br>      "ap-southeast-1a": "10.0.1.0/24",<br>      "ap-southeast-1b": "10.0.2.0/24",<br>      "ap-southeast-1c": "10.0.3.0/24"<br>    }<br>  }<br>}</pre> |    no    |

## Outputs

| Name                                                                                                            | Description                             |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| <a name="output_amazon_linux_2_ami_id"></a> [amazon\_linux\_2\_ami\_id](#output\_amazon\_linux\_2\_ami\_id)     | Ami id of the amazon linux 2 image      |
| <a name="output_aws_instance_public_ips"></a> [aws\_instance\_public\_ips](#output\_aws\_instance\_public\_ips) | Public Ips of EC2 instances             |
| <a name="output_efs_filesystem_dns_name"></a> [efs\_filesystem\_dns\_name](#output\_efs\_filesystem\_dns\_name) | DNS name of the created EFS file system |
| <a name="output_efs_filesystem_id"></a> [efs\_filesystem\_id](#output\_efs\_filesystem\_id)                     | DNS name of the created EFS file system |
