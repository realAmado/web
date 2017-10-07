/*
variable "access_key" {
    description = "The AWS access key."
}
variable "secret_key" {
    description = "The AWS secret key."
}
*/
variable "region" {
  description = "The AWS region."
}

variable "key_name" {
  description = "The AWS key pair to use for resources."
}

variable "ami" {
  type        = "map"
  description = "A map of AMIs."
  default     = {}
}

variable "instance_type" {
  description = "The instance type."
  default     = "t2.micro"
}
