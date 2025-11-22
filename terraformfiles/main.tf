provider "aws" {
  region = "us-east-1"   
}

resource "aws_instance" "test-server" {
  ami                    = "ami-0fa3fe0fa7920f68e"          
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-018becd0736e04e44"]        

  # Automatically configure server at launch
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    docker run -d -p 80:80 tejasgowramma123/zomatoapp
  EOF

  tags = {
    Name = "test-server"
  }

  # Save public IP to inventory file
  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }
}
