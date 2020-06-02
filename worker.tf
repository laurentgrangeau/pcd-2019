resource "aws_instance" "workers" {
  ami = "ami-08af7eec3de69f5f8"
  instance_type = "t2.micro"
  count = 3
  key_name = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.pcd-2019-kubernetes.id}"]
  private_ip = "10.240.0.2${count.index}"
  subnet_id = "${aws_subnet.kubernetes.id}"

  tags = {
    Name = "worker-${count.index}"
  }
}