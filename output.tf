##Output
output "public_ip" {
  value = aws_eip.eip[*]
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db_instance.endpoint
}