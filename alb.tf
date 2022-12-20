##ALB
resource "aws_lb" "alb" {
  name               = "${var.general_config["project"]}-${var.general_config["environment"]}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public-subnets["public-1a"].id, aws_subnet.public-subnets["public-1c"].id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-alb"
  }
}

##Target Group
resource "aws_lb_target_group" "tg" {
  name             = "${var.general_config["project"]}-${var.general_config["environment"]}-tg"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = "80"
  protocol         = "HTTP"
  vpc_id           = aws_vpc.vpc.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-tg"
  }
}

##Attach target group to the alb
resource "aws_lb_target_group_attachment" "tg-to-ec2" {
  for_each         = aws_instance.ec2-instance
  target_id        = each.value.id
  target_group_arn = aws_lb_target_group.tg.arn
}

##Listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}