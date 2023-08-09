variable "profile" {
  type        = string
  description = "profile of AWS cli to access from terraform"
}

variable "app_instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t2.micro"
}

variable "app_instance_name" {
  type        = string
  description = "ec2 instance name"
  default     = "app"
}

variable "db_instance_type" {
  type        = string
  description = "database instance type"
  default     = "db.t3.micro"
}

variable "db_instance_name" {
  type        = string
  description = "database instance name"
  default     = "db"
}