# 2_tier_architecture with aws module

My second hobby project. It creates Virtual Private Cloud(VPS) in singapore region, Public Subnet for application server(app), Private Subnet for database(db) first. Security groups related to app and db are created afterwards. And finally it creates app and db in the end. It architecutrual diagram is as follows;

<p align="center">
  <img
    width="400"
    src="https://raw.githubusercontent.com/slientskyslayer330/AWSTerraforming/main/2-tier-architecture/Diagram/2_tier_architecture.png"
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

| Name                                                       | Version |
| ---------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws)          | 5.11.0  |
| <a name="provider_local"></a> [local](#provider\_local)    | 2.4.0   |
| <a name="provider_null"></a> [null](#provider\_null)       | 3.2.1   |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1   |
| <a name="provider_tls"></a> [tls](#provider\_tls)          | 4.0.4   |

## Modules

| Name                                                                       | Source                                   | Version  |
| -------------------------------------------------------------------------- | ---------------------------------------- | -------- |
| <a name="module_app_instance"></a> [app\_instance](#module\_app\_instance) | terraform-aws-modules/ec2-instance/aws   | n/a      |
| <a name="module_app_sg"></a> [app\_sg](#module\_app\_sg)                   | terraform-aws-modules/security-group/aws | >= 5.1.0 |
| <a name="module_database_sg"></a> [database\_sg](#module\_database\_sg)    | terraform-aws-modules/security-group/aws | >= 5.1.0 |
| <a name="module_db"></a> [db](#module\_db)                                 | terraform-aws-modules/rds/aws            | n/a      |
| <a name="module_testing_vpc"></a> [testing\_vpc](#module\_testing\_vpc)    | terraform-aws-modules/vpc/aws            | n/a      |

## Resources

| Name                                                                                                                | Type        |
| ------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_key_pair.ec2_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)   | resource    |
| [local_file.ssh_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)            | resource    |
| [null_resource.instance](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)     | resource    |
| [random_password.db](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)       | resource    |
| [tls_private_key.key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource    |
| [aws_ami.amazon_linux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)         | data source |

## Inputs

| Name                                                                                      | Description                                 | Type     | Default         | Required |
| ----------------------------------------------------------------------------------------- | ------------------------------------------- | -------- | --------------- | :------: |
| <a name="input_app_instance_name"></a> [app\_instance\_name](#input\_app\_instance\_name) | ec2 instance name                           | `string` | `"app"`         |    no    |
| <a name="input_app_instance_type"></a> [app\_instance\_type](#input\_app\_instance\_type) | ec2 instance type                           | `string` | `"t2.micro"`    |    no    |
| <a name="input_db_instance_name"></a> [db\_instance\_name](#input\_db\_instance\_name)    | database instance name                      | `string` | `"db"`          |    no    |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type)    | database instance type                      | `string` | `"db.t3.micro"` |    no    |
| <a name="input_profile"></a> [profile](#input\_profile)                                   | profile of AWS cli to access from terraform | `string` | n/a             |   yes    |

## Outputs

| Name                                                                                                   | Description                         |
| ------------------------------------------------------------------------------------------------------ | ----------------------------------- |
| <a name="output_amazon_linux2_ami_id"></a> [amazon\_linux2\_ami\_id](#output\_amazon\_linux2\_ami\_id) | ami-id of amd64 ubuntu in singapore |
| <a name="output_instance_ip"></a> [instance\_ip](#output\_instance\_ip)                                | public ip of app instance           |
| <a name="output_master_password"></a> [master\_password](#output\_master\_password)                    | password of rds master              |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint)                             | rds endpoint                        |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username)                             | rds username                        |
