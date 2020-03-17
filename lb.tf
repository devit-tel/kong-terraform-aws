# External - TLS only
resource "aws_lb_target_group" "external" {
  count = var.enable_external_lb ? 1 : 0

  name     = format("%s-%s-external", var.service, var.environment)
  port     = 8000
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-external", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb" "external" {
  count = var.enable_external_lb ? 1 : 0

  name     = format("%s-%s-external", var.service, var.environment)
  internal = false
  subnets  = var.public_subnet_ids
  load_balancer_type = "network"
  #security_groups = [aws_security_group.external-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

  tags = merge(
    {
      "Name"        = format("%s-%s-external", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_listener" "external-https" {
  count = var.enable_external_lb ? 1 : 0

  load_balancer_arn = aws_lb.external[0].arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_external_arn

  default_action {
    target_group_arn = aws_lb_target_group.external[0].arn
    type             = "forward"
  }
}

# Internal
resource "aws_lb_target_group" "internal" {
  count = var.enable_internal_lb ? 1 : 0

  name     = format("%s-%s-internal", var.service, var.environment)
  port     = 8000
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-internal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "admin" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-admin", var.service, var.environment)
  port     = 8001
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-admin", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "manager" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-manager", var.service, var.environment)
  port     = 8002
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-manager", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "portal-gui" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-porter-gui", var.service, var.environment)
  port     = 8003
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-porter-gui", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_target_group" "portal" {
  count = var.enable_ee ? 1 : 0

  name     = format("%s-%s-portal", var.service, var.environment)
  port     = 8004
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    path                = "/status"
    port                = 8000
    # timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    {
      "Name"        = format("%s-%s-portal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb" "internal" {
  count = var.enable_internal_lb ? 1 : 0

  name     = format("%s-%s-internal", var.service, var.environment)
  internal = true
  subnets  = var.private_subnet_ids
  load_balancer_type = "network"
  # security_groups = [aws_security_group.internal-lb.id]

  enable_deletion_protection = var.enable_deletion_protection
  idle_timeout               = var.idle_timeout

  tags = merge(
    {
      "Name"        = format("%s-%s-internal", var.service, var.environment),
      "Environment" = var.environment,
      "Description" = var.description,
      "Service"     = var.service,
    },
    var.tags
  )
}

resource "aws_lb_listener" "internal-http" {
  count = var.enable_internal_lb ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.internal[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "internal-https" {
  count = var.enable_internal_lb ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 443
  protocol          = "TLS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_internal_arn

  default_action {
    target_group_arn = aws_lb_target_group.internal[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "admin" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8444
  protocol          = "TLS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_admin_arn

  default_action {
    target_group_arn = aws_lb_target_group.admin[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "manager" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8445
  protocol          = "TLS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_manager_arn

  default_action {
    target_group_arn = aws_lb_target_group.manager[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "portal-gui" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8446
  protocol          = "TLS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_portal_arn

  default_action {
    target_group_arn = aws_lb_target_group.portal-gui[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "portal" {
  count = var.enable_ee ? 1 : 0

  load_balancer_arn = aws_lb.internal[0].arn
  port              = 8447
  protocol          = "TLS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.ssl_cert_portal_arn

  default_action {
    target_group_arn = aws_lb_target_group.portal[0].arn
    type             = "forward"
  }
}
