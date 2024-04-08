resource "aws_spot_instance_request" "rabbitmq" {
  ami = data.aws_ami.ami.id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[0]
  wait_for_fulfillment = true
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh",
    {
      component = "rabbitmq"
      env = var.env
    }))

  tags = merge(
    var.tags ,
    { Name = "${var.env}-rabbitmq"}
  )
}


resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.domain.zone_id #saraldevops.online ki zone id mil jaegi
  name    = "rabbitmq-${var.env}.${var.dns_domain}"
  type    = "A"
  ttl     = 30 # response time
  records = [aws_spot_instance_request.rabbitmq.private_ip] # to get the records
}

resource "aws_security_group" "main" {
  name = "rabbitmq-${var.env}"
  description = "rabbotmq-${var.env}-description"
  vpc_id = var.vpc_id


  ingress {

    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr
  }

  ingress {

    description = "RABBITMQ"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = var.allow_subnets
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
  var.tags ,
  { Name = "rabbitmq-${var.env}"}
  )

  }