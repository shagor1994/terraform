#create a network load balancer and target group for the VPC endpoint service and target instances
resource "aws_lb" "nlb" {
  name               = "vpc-endpoint-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.vpc_b_subnet_1.id, aws_subnet.vpc_b_subnet_3.id]

  tags = {
    Name = "vpc-endpoint-nlb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "vpc-endpoint-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc_b.id

  health_check {
    interval            = 30
    protocol            = "TCP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "vpc-endpoint-tg"
  }
}

resource "aws_lb_target_group_attachment" "web_server_1_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server_2_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


