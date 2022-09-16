
# if you leave out the value in default, you will be prompted for the input when you run terraform apply
# OR use cli args
# terraform apply -var "region=us-east-1"

variable "region" {
  default = "us-east-1"
  type = string
  description = ""
}

variable "ami_id" {
  default = "ami-06640050dc3f556bb"
  type = string
  description = ""
}

variable "access_key" {
  default = ""
  type = string
  description = ""
  sensitive = true
}

variable "secret_key" {
  default = ""
  type = string
  description = ""
  sensitive = true
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhlNuPJVBkPb57KAN/t4wfyghZ2gYqqfAf5eXW9Ii5A1qRZOIoo97XHofQLIXvbYMIpX57fqt4snWzsaOUsARGAT7O1hAyskW/84EHJ7m9fO2cH0sJe9M+aFvu3N8XzAjWOWM6TXQ8ySrCSsHcoHxhe9iaL3ogZ5xIQCt79dqKuecGQLJfWk5F9F7LYFKQoy5i3LRaeIsNKV7/cOoYeVsToOsBzt090usQAjN+ukhkATdOlyZlce6bZ6PzRNowJNGfQdBzqjR75GUf+D5VppAD/CANJcDewZTSIDa+KhQJjNyprD2FKFWveM9ebG9CwS+kyCbCEw/36PtmNxpnYshr ec2-user"
  type = string
  description = ""
}

