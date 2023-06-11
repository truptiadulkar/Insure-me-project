resource "aws_instance" "test-server" {
  ami                    = "ami-049a62eb90480f276"
  instance_type          = "t2.micro"
  key_name               = "keypairpem"
  vpc_security_group_ids = ["sg-0a5b8d6ca31ae2d81"]

  tags = {
    Name = "test-server"
  }
  
   Provisioner "local-exec" {
   Command = "sleep 60 && echo 'Instance ready' "
  }
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./keypairpem.pem")
    host        = self.public_ip 
  }
   
  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/Finance-project/test-server/Deploy.yml"
  }
}

