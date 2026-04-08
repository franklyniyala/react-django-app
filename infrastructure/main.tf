resource "aws_instance" "react-django-ec2-server" {
  ami                         = "ami-01b14b7ad41e17ba4"
  instance_type               = "m7i-flex.large"
  subnet_id                   = aws_subnet.react-django-subnet.id
  vpc_security_group_ids      = [aws_security_group.react-django-sg.id]
  key_name                    = "jay"
  associate_public_ip_address = true

  tags = {
    Name = "react-django-ec2-server"
  }
}