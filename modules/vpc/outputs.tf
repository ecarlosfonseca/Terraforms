output "vpc_security_group_id" {
  value = aws_security_group.tutorials_vpc_sg.id
}

output "database_security_group_id" {
  value = aws_security_group.tutorials_database_sg.id
}

output "subnet1_public_id" {
  value = aws_subnet.subnet1_public.id
}

output "subnet2_private_id" {
  value = aws_subnet.subnet2_private.id
}
