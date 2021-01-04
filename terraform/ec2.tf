resource "aws_key_pair" "terraform_host_key" {
  key_name   = "${local.environment}_id_rsa.pub"
  public_key = file("${path.cwd}/tf_rsa.pub")
}

//data "aws_ami" "al2" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  owners = ["amazon"]
//}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "example" {
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  key_name = aws_key_pair.terraform_host_key.key_name
//  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data = <<-EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p ${local.port} &
EOF
//  sudo yum install -y https://s3.${local.region}.amazonaws.com/amazon-ssm-${local.region}/latest/linux_arm64/amazon-ssm-agent.rpm > index.html
// aws s3api get-object --bucket splitnote-builds-bucket --key latest index.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

//  ingress {
//    from_port = local.port
//    protocol = "tcp"
//    to_port = local.port
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
////  egress {
////    from_port = 0
////    to_port = 0
////    protocol = "-1"
////    cidr_blocks = ["0.0.0.0/0"]
////  }
}

resource "aws_security_group_rule" "allow-all-inbound" {
  type              = "ingress"
  from_port = local.port
  to_port = local.port
//  protocol = "tcp"
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "allow-all-outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance.id
}