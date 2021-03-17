resource "aws_db_subnet_group" "tutorials-gp" {
  name       = "${var.app_name}-subnet-gp"
  subnet_ids = [var.subnet1_public_id, var.subnet2_private_id]

  tags = {
    Name = "${var.app_name}-subnet-gp"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = "9.6.9"
  instance_class              = "db.t2.micro"
  name                        = "${var.app_name}rds"
  username                    = "postgres"
  password                    = "password"
  db_subnet_group_name        = aws_db_subnet_group.tutorials-gp.name
  vpc_security_group_ids      = [var.security_group]
  skip_final_snapshot = true
}
