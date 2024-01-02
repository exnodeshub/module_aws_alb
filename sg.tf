################################################
# Security Group
################################################
resource "aws_security_group" "general-load-balancer" {
  name        = "${var.env_name}-${var.repository_name}-lb-sg"
  description = "Controls access to the ALB"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-${var.repository_name} Loadbalancer Security Group"
  }
}

# ECS Security group (traffic ALB -> ECS)
resource "aws_security_group" "general-ecs" {
  name        = "${var.env_name}-${var.repository_name}-ecs-sg"
  description = "Allows inbound access from the ALB only"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.general-load-balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-${var.repository_name} ECS Service Security Group"
  }
}