##EC2
resource "aws_instance" "ec2-instance" {
  ami                    = "${var.ami}"
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.ec2.id]
  subnet_id              = "${var.availability_zones["ap-northeast-1a"]}"
  key_name               = aws_key_pair.key.id
  instance_type          = "${var.instance_type}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  tags = {
    Name = "example"
  }
}

##Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.ec2-instance.id
  vpc      = true
}

##Key Pair
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/example.pub")
}