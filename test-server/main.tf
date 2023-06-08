resource "aws_instance" "test-server" {
  ami                    = "ami-049a62eb90480f276"
  instance_type          = "t2.micro"
  key_name               = "keypairdoc"
  vpc_security_group_ids = ["sg-0ddc4a835e0d5e85c"]

  tags = {
    Name = "test-server"
  }
 
  provisioner "local-exec" {
   command = [ "sleep 60", "echo 'Instance ready'"]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./keypairdoc.pem")
    host        = self.public_ip 
  }
   
  provisioner "local-exec" {
   command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/Insure-me-project/Deploy.yml "
  }
}

