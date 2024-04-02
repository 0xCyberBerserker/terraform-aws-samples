output "web_instance_ip" {
    value = aws_instance.wordpress_instance.public_ip
}

output "aws_lnx2_ami" {
  value = data.aws_ami.aws_lnx2_ami.id
}

output "DatabaseName" {
value = aws_db_instance.wordpressbackend.name
description = "The Database Name!"
}
output "DatabaseUserName" {
value = aws_db_instance.wordpressbackend.username
description = "The Database UserName!"
}
output "DBConnectionString" {
value = aws_db_instance.wordpressbackend.endpoint
description = "The Database connection String!"
}
output "DBPassword" {
value = aws_db_instance.wordpressbackend.password
description = "The Database Password!"
}
output "DBEndpoint" {
value = aws_db_instance.wordpressbackend.endpoint
description = "The Database Endpoint!"
}
