# Configure the AWS provider
provider "aws" {
  region = "ap-south-1" # Update with your desired region
  access_key = var.asw_access_key
  secret_key =  var.asw_secret_key
}



# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa-4096.private_key_pem
    filename = var.key_pair

}

# Create a security group
resource "aws_security_group" "web_server_security_terraform_staging" {
  name = "web-server-terraform-staging"
  description = "Security group for web server"

  ingress {
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (restrict for production)
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere (restrict for production)
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance
resource "aws_instance" "web_server_terraform_staging" {
  ami           = var.aws_ami_id # Update with desired AMI ID 
  instance_type =  var.instance_type  #"t2.micro"

  vpc_security_group_ids = [aws_security_group.web_server_security_terraform_staging.id]
  
  key_name = aws_key_pair.key_pair.key_name

  # Additional configuration (user data, tags, etc.)
  tags = {
    name = "web_server_terraform_staging"
  }
}





# Output the public IP address of the instance (if applicable)
output "public_ip" {
  value = aws_instance.web_server_terraform_staging.public_ip
}
