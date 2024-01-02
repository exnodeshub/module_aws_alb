# ################################################
# # Loadbalancer
# ################################################
resource "aws_lb" "general-alb" {
    name                             = "${var.env_name}-${var.repository_name}-alb"
    load_balancer_type               = "application"
    internal                         = false
    security_groups                  = [aws_security_group.general-load-balancer.id]
    subnets                          = [var.public_subnet_1_id, var.public_subnet_2_id]
    enable_cross_zone_load_balancing = true
    tags = {
        Name = "${var.env_name}-${var.repository_name}-alb"
    }
}

# Target group
resource "aws_alb_target_group" "target-group-blue" {
    name        = "${var.env_name}-${var.repository_name}-tg-blue"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.aws_vpc_id
    target_type = "ip"

  health_check {
    path                = var.health_check_path # "/ping/" # Will create health check endpoint later
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 6
    timeout             = 10
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "${var.env_name}-${var.repository_name}-tg-blue"
  }
}

resource "aws_alb_target_group" "target-group-green" {
    name        = "${var.env_name}-${var.repository_name}-tg-green"
    port        = var.container_port
    protocol    = "HTTP"
    vpc_id      = var.aws_vpc_id
    target_type = "ip"

    health_check {
        path                = var.health_check_path # "/ping/" # Will create health check endpoint later
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 6
        timeout             = 10
        interval            = 30
        matcher             = "200"
    }

    tags = {
        Name = "${var.env_name}-${var.repository_name}-tg-green"
    }
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "ecs-alb-http-listener" {
    load_balancer_arn = aws_lb.general-alb.arn
    port              = "80"
    protocol          = "HTTP"
    # depends_on        = [aws_alb_target_group.target-group-blue]
    default_action {
        type = "redirect"
        redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
        }
    }
    lifecycle {
        ignore_changes = [
          default_action
        ]
    }
}
# Target listener for https:443
resource "aws_alb_listener" "ecs-alb-https-listener" {
    load_balancer_arn = aws_lb.general-alb.id
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    default_action {
        type = "fixed-response"

        fixed_response {
        content_type = "text/plain"
        message_body = "Not found!"
        status_code  = "404"
        }
    }
  certificate_arn = var.ecs_alb_certificate_arn
}

resource "aws_lb_listener_certificate" "ecs-alb-certificate" {
  listener_arn    = aws_alb_listener.ecs-alb-https-listener.arn
  certificate_arn = var.ecs_alb_certificate_arn
}
resource "aws_lb_listener_rule" "ecs-alb-listener-rule" {
    listener_arn = aws_alb_listener.ecs-alb-https-listener.arn
    priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target-group-blue.arn
  }

  condition {
    host_header {
      values = var.domains
    }
  }
  lifecycle {
    ignore_changes = [
      action,
      # condition
    ]
  }
}