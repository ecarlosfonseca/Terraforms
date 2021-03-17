resource "aws_instance" "tutorials" {
  ami                         = "ami-830c94e3"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet1_public_id
  vpc_security_group_ids      = [var.vpc_security_group_id]
  associate_public_ip_address = "true"
  key_name                    = "tutorialsfinalpairkey"

  tags = {
    Name = "${var.app_name}ec2instance"
  }
}



