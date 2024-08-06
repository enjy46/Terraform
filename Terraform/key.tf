resource "tls_private_key" "team2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "team2_key" {
  key_name   = "team2-key.pem"
  public_key = tls_private_key.team2_key.public_key_openssh
}