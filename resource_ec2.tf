data "aws_ami" "ubuntu24_arm64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "aws_key_pair" "mykey" {
  key_name = "id_ed25519-skokado"
}

resource "aws_security_group" "ssh" {
  name   = "ssh-to-ec2"
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-to-ec2"
  }
}

resource "aws_security_group" "web" {
  name   = "web-traffic"
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "http-to-ec2"
  }
}

resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu24_arm64.id
  instance_type = "t4g.nano"
  key_name      = data.aws_key_pair.mykey.key_name

  subnet_id = data.aws_subnets.public.ids[0]
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.web.id,
  ]
  iam_instance_profile = aws_iam_instance_profile.this.name

  tags = {
    Name = "my-nginx"
  }
}
resource "aws_eip" "nginx" {
  instance = aws_instance.nginx.id
  domain   = "vpc"
}
