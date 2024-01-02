# module_aws_alb  
My module alb aws

## Getting started  
config git credentical for private repo   
href: https://gitlab.com/exnodes-new/terraform-core/-/tree/master/modules/module_aws_alb?ref_type=heads 

add module    
example:       
```JavaScript

module "example_alb_sg" {
  source = "./modules/module_aws_alb"
  repository_name = "service-api"
  env_name = "prod"
  container_port = 8000
  aws_vpc_id = "your vpc id"
  public_subnet_2_id = "your public subnet 2 id"
  public_subnet_1_id = "your public subnet 1 id"
  ecs_alb_certificate_arn = "your ecs certificate arn"
  domains = ["api.example.com"]
  health_check_path = "/ping/"
}
```

# Input 
```JavaScript
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
```

# Output 
```JavaScript
# Load balancer
output "alb_dns_name" {
  description = "Get alb dns"
  value = aws_lb.general-alb.dns_name
}
output "alb_zone_id" {
  description = "Get alb zone_id"
  value = aws_lb.general-alb.zone_id
}
output "ecs_alb_target_group_blue_arn" {
  description = "Get alb target group blue arn"
  value = aws_alb_target_group.target-group-blue.arn
}
output "ecs_alb_target_group_green_arn" {
  description = "Get alb target group green arn"
  value = aws_alb_target_group.target-group-green.arn
}
output "ecs_alb_target_group_blue" {
  description = "Get alb target group blue"
  value = aws_alb_target_group.target-group-blue
}
output "ecs_alb_target_group_green" {
  description = "Get alb target group green"
  value = aws_alb_target_group.target-group-green
}
output "ecs_alb_http_listener" {
  description = "Listener (redirects traffic from the load balancer to the target group)"
  value = aws_alb_listener.ecs-alb-http-listener
}
output "ecs_alb_https_listener" {
  description = "Target listener for https:443"
  value = aws_alb_listener.ecs-alb-https-listener
}
output "ecs_alb_certificate" {
  description = "ECS alb certificate"
  value = aws_lb_listener_certificate.ecs-alb-certificate
}
output "aws_lb_listener_rule_arn" {
  description = "Load balancer rule arn"
  value = aws_lb_listener_rule.ecs-alb-listener-rule.arn
}
# Security group
output "security_group_id" {
  description = "Get security group id"
  value = aws_security_group.general-ecs.id
}
output "security_group_load_balancer_id" {
  description = "Get security group load balancer id"
  value = aws_security_group.general-load-balancer.id
}
```