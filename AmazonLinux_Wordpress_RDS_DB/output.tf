output "web_instance_ip" {
    value = module.wordpress[0].public_ip
}

output "aws_lnx2_ami" {
  value = data.aws_ami.aws_lnx2_ami.id
}

output "DatabaseName" {
value = aws_db_instance.wordpressbackend.db_name
description = "The Database Name!"
}
output "DatabaseUserName" {
value = aws_db_instance.wordpressbackend.username
description = "The Database UserName!"
sensitive = true
}

output "DBPassword" {
value = aws_db_instance.wordpressbackend.password
description = "The Database Password!"
sensitive = true
}
output "DBEndpoint" {
value = aws_db_instance.wordpressbackend.endpoint
description = "The Database Endpoint!"
}
