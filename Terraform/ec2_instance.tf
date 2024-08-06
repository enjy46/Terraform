resource "aws_instance" "team2_ec2" {
  ami           = "ami-0862be96e41dcbf74"  # Ubuntu Server 24.04 LTS
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id  # Use index 0 to reference the first subnet
  vpc_security_group_ids = [aws_security_group.team2_sg.id]
  key_name               = aws_key_pair.team2_key.key_name

  tags = {
    Name = "team2-ec2-instance"
  }
}
