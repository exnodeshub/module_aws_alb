# Load balancer
variable "aws_vpc_id" {
    description = "VPC ID"
    type        = string
}
variable "env_name" {
  description = "Define environment name"
  type = string
}
variable "domains" {
  description = "List domain"
  type        = list(string)
}
variable "repository_name" {
    description = "Repository name"
    type        = string
}
variable "public_subnet_1_id" {
  description = "Public subnet 1 ID from module VPC"
  type        = string
}
variable "public_subnet_2_id" {
  description = "Public subnet 2 ID from module VPC"
  type        = string
}
variable "container_port" {
    description = "aws_alb_target_group port"
    type = number
}
variable "health_check_path" {
  description = "Health check path"
  type        = string
  default = "/ping/"
}
variable "ecs_alb_certificate_arn" {
    description = "ecs_alb_certificate_arn arn"
    type = string
}