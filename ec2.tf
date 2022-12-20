##EC2
resource "aws_instance" "ec2-instance" {
  ami                    = var.ami
  subnet_id              = var.subnets.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.common.id, aws_security_group.ec2.id]
  key_name               = aws_key_pair.key.id
  instance_type          = var.instance_type
  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["environment"]}-${var.general_config["type"]}01"
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