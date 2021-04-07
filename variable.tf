variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "Common Tags to all resources"
  type = map
}
variable "key_name" {
  description = "The name of the SSH key that will be generated"
  type = string
}