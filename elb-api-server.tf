resource "aws_elb" "elb-api-server" {
  name               = "elb-api-server"
  subnets = ["${aws_subnet.kubernetes.id}"]

  listener {
    instance_port     = 6443
    instance_protocol = "https"
    lb_port           = 6443
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:6443/"
    interval            = 30
  }

  instances                   = ["${aws_instance.controller-master.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "elb-api-server"
  }
}