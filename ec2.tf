##EC2
resource "aws_instance" "ec2-instance" {
  ami                    = var.ami
  for_each               = var.subnets.public_subnets
  subnet_id              = aws_subnet.public-subnets[each.key].id
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.ec2.id]
  key_name               = aws_key_pair.key.id
  instance_type          = var.instance_type
  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-${var.general_config["type"]}"
  }
}

##Elastic IP
resource "aws_eip" "eip" {
  for_each = aws_instance.ec2-instance
  instance = each.value.id
  vpc      = true
}

##Key Pair
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/example.pub")
}