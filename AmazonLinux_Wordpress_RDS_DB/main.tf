terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  profile = var.profile_name
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "app-vpc"
  }
}
### Create an Internet Gateway ###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}
### Create a Public Subnet ###
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags = {
    Name = "public-subnet"
  }
}
### Create a Public Route Table ###
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}
### Associate the Route Table with the Subnet ###
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


### Locate Amazon Linux 2 AMI ID ###
data "aws_ami" "aws_lnx2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
### Create an EC2 Instance ###
resource "aws_instance" "wordpress_instance" {
  ami = data.aws_ami.aws_lnx2_ami.id
  instance_type = var.instance_type
  key_name = var.instance_key
  subnet_id              = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]
  
  provisioner "file"  {
    source = "./templates/wp-config.php"
    destination = "/tmp/wp-config.php"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/pem/testing.pem")
    host        = self.public_ip
  }

  user_data = filebase64("./templates/install.sh")

  tags = {
    Name = "wordpress_instance"
  }

  volume_tags = {
    Name = "wordpress_instance"
  } 
}



#RDS INSTANCE
resource "aws_db_instance" "wordpressbackend" {
  instance_class = "db.t3.micro"
  engine = "mysql"
  publicly_accessible = false
  allocated_storage = 20
  name = "wordpress"
  username = aws_ssm_parameter.db_username.value
  password = aws_ssm_parameter.db_password.value
  skip_final_snapshot = true
  tags = {
    app = "mysql"
  }
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "db_endpoint"
  type  = "String"
  value = aws_db_instance.wordpressbackend.endpoint
}

resource "aws_ssm_parameter" "db_username" {
  name  = "db_username"
  type  = "String"
  value = "TESTUSER"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "db_password"
  type  = "TESTTESTTEST"
  value = aws_db_instance.wordpressbackend.password
}