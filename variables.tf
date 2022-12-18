##General Config
variable "general_config" {
  description = "Project and Environment name"
  default = {
    project     = "example"
    environment = "stg"
  }
}

##Network
variable "vpc" {
  description = "CIDR BLOCK for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_1a" {
  default = ["ap-northeast-1a"]
}

variable "availability_zone_1c" {
  default = ["ap-northeast-1c"]
}

variable "public_subnet_1a" {
  default = ["10.0.10.0/24"]
}

variable "public_subnet_1c" {
  default = ["10.0.30.0/24"]
}

variable "private_subnet_1a" {
  default = ["10.0.20.0/24"]
}

variable "private_subnet_1c" {
  default = ["10.0.40.0/24"]
}

##EC2
variable "ami" {
  description = "ID of AMI to use for ec2 instance"
  default     = "ami-0bba69335379e17f8"
}

variable "instance_type" {
  description = "The type of instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "key name of the key pair"
  type        = string
  default     = "example"
}