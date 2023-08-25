# autoscaling

Simple use case of AWS application load balancer with 2 ec2 instances


<p align="center">
  <img
    width="400"
    src="https://raw.githubusercontent.com/slientskyslayer330/AWSTerraforming/main/autoscaling/diagram/autoscaling.png"
    alt="2-tier-architecture"
  />
</p>


## How to use

You need to only gives your pre-setup profile value for the code to run.


## Requirements

| Name                                                                      | Version  |
| ------------------------------------------------------------------------- | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 5.9.0 |

## Providers

| Name                                              | Version |
| ------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.13.1  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                 | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_alb.test_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb)                                                                  | resource    |
| [aws_alb_listener.test_alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener)                                       | resource    |
| [aws_alb_target_group.apps_alb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group)                                     | resource    |
| [aws_alb_target_group_attachment.apps_attachment_to_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group_attachment)    | resource    |
| [aws_instance.apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                            | resource    |
| [aws_internet_gateway.non_prod_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                    | resource    |
| [aws_route.public_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                          | resource    |
| [aws_route_table.private_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                      | resource    |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                        | resource    |
| [aws_route_table_association.route_table_assoc_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource    |
| [aws_route_table_association.route_table_assoc_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)          | resource    |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                              | resource    |
| [aws_security_group.app_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                              | resource    |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                     | resource    |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                      | resource    |
| [aws_vpc.non_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                  | resource    |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                         | data source |
| [aws_availability_zones.singapore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)                                | data source |

## Inputs

| Name                                                    | Description                                 | Type     | Default | Required |
| ------------------------------------------------------- | ------------------------------------------- | -------- | ------- | :------: |
| <a name="input_profile"></a> [profile](#input\_profile) | profile of AWS cli to access from terraform | `string` | n/a     |   yes    |

## Outputs

| Name                                                                                                       | Description                  |
| ---------------------------------------------------------------------------------------------------------- | ---------------------------- |
| <a name="output_alb_attached_instances"></a> [alb\_attached\_instances](#output\_alb\_attached\_instances) | id of alb attached instances |
| <a name="output_alb_dns"></a> [alb\_dns](#output\_alb\_dns)                                                | dns of alb                   |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids)                                 | id of app instances          |
