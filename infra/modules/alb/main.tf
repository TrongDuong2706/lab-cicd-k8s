resource "aws_lb" "main_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.public_sg_id]
  internal           = false

  enable_deletion_protection = false

  tags = merge(var.tags, { Name = var.alb_name })
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_ingress_tg.arn
  }
}

resource "aws_lb_target_group" "k8s_ingress_tg" {
  name        = var.k8s_target_group_name
  port        = var.k8s_target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

   health_check {
    path                = "/healthz"   
    protocol            = "HTTP"
    port                = "traffic-port" 
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, { Name = var.k8s_target_group_name })
}

resource "aws_lb_target_group_attachment" "k8s_host_attachment" {
  target_group_arn = aws_lb_target_group.k8s_ingress_tg.arn
  target_id        = var.k8s_node_id
  port             = var.k8s_target_port
}

resource "aws_lb_target_group" "jenkins_tg" {
  name        = var.jenkins_target_group_name
  port        = var.jenkins_target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/login"
    protocol = "HTTP"
    matcher  = "200"
    interval = 30
    timeout  = 10
  }

  tags = merge(var.tags, { Name = var.jenkins_target_group_name })
}

resource "aws_lb_target_group_attachment" "jenkins_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = var.jenkins_node_id
  port             = var.jenkins_target_port
}

resource "aws_lb_listener_rule" "jenkins_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = var.jenkins_listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }

  condition {
    host_header {
      values = [var.full_jenkins_domain_name]
    }
  }
}