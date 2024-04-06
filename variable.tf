variable "aws_ami_id" {
  type = string
  description = "this id  will be appear wnen you click a lunch instance  and below and instance type"
}

variable "instance_type" {
  type = string
  description = "instance type means instance is micro and medium i.e t2.micro"
}

variable "key_pair" {
  type = string
}

variable "asw_access_key" {
  type = string
  description = "aws access key while creating form IAM Roles"
}

variable "asw_secret_key" {
  type = string
  description = "aws secret key while creating form IAM Roles, like password"
}