output "web_instance_ip" {
    value = aws_instance.web.public_ip
}

output "aws_lnx2_ami" {
  value = data.aws_ami.aws_lnx2_ami.id
}