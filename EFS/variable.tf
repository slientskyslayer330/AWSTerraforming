variable "aws_access_key" {
  type        = string
  description = "Access key of AWS to access from terraform"
  sensitive   = true
}
variable "aws_secret_key" {
  type        = string
  description = "Secret key of AWS to access from terraform"
  sensitive   = true
}

variable "subnets" {
  description = "subnets ips and zones"
  type = map(object({
    cidrs = object({
      ap-southeast-1a = string
      ap-southeast-1b = string
      ap-southeast-1c = string
    })
  }))
  default = {
    public = {
      cidrs = {
        ap-southeast-1a = "10.0.1.0/24"
        ap-southeast-1b = "10.0.2.0/24"
        ap-southeast-1c = "10.0.3.0/24"
      }
    }
    private = {
      cidrs = {
        ap-southeast-1a = "10.0.128.0/20"
        ap-southeast-1b = "10.0.144.0/20"
        ap-southeast-1c = "10.0.160.0/20"
      }
    }
  }
}

variable "application_instance_size" {
  type        = string
  description = "instance size of application server"
  default     = "t2.micro"
}

variable "application_instance_azs" {
  type        = list(string)
  description = "azs of application instances"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "efs_mount_point" {
  type = string
  description = "Mount path of EFS in EC2 instance"
  default = "/mnt/efs/fs1"
}