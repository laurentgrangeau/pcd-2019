provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_instance" "controller-master" {
  ami = "ami-08af7eec3de69f5f8"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.pcd-2019-kubernetes.id}"]
  private_ip = "10.240.0.10"
  subnet_id = "${aws_subnet.kubernetes.id}"
  
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/Users/laurentgrangeau/.ssh/id_rsa")}"
    host = "${aws_instance.controller-master.public_ip}"
  }

  provisioner "file" {
    source      = "ca"
    destination = "~"
  }

  provisioner "file" {
    source      = "encryption"
    destination = "~"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "~"
  }
  
  provisioner "file" {
    source      = "config"
    destination = "~"
  }
  
  provisioner "file" {
    source      = "systemd"
    destination = "~"
  }
  
  provisioner "file" {
    source = "aws"
    destination = "~/.aws/"
  }

  provisioner "file" {
    source = "/Users/laurentgrangeau/.ssh/id_rsa"
    destination = "~/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "export DEBIAN_FRONTEND=noninteractive",
      "chmod u+x ~/scripts/*.sh",
      "chmod 700 /home/ubuntu/.ssh/id_rsa",
      "cd ~/scripts/",
      "./01-prepare.sh",
      "./02-generate-ca-certificates.sh",
      "./03-generate-admin-certificates.sh",
      "./04-generate-client-certificates.sh",
      "./05-generate-controller-manager-certificates.sh",
      "./06-generate-proxy-client-certificates.sh",
      "./07-generate-scheduler-client-certificates.sh",
      "./08-generate-api-server-certificates.sh",
      "./09-generate-service-account-certificates.sh",
      "./10-copy-pem.sh",
      "./11-generate-kubeconfig.sh",
      "./12-copy-kubeconfig.sh",
      "./13-generate-encryption-config.sh",
    ]
  }

  tags = {
    Name = "controller-0"
  }
}

resource "aws_instance" "controller-backup" {
  ami = "ami-08af7eec3de69f5f8"
  instance_type = "t2.micro"
  count = 2
  key_name = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.pcd-2019-kubernetes.id}"]
  private_ip = "10.240.0.1${count.index + 1}"
  subnet_id = "${aws_subnet.kubernetes.id}"

  tags = {
    Name = "controller-${count.index + 1}"
  }
}

resource "aws_vpc" "kubernetes" {
  cidr_block = "10.240.0.0/16"
}

resource "aws_subnet" "kubernetes" {
  vpc_id     = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.240.0.0/24"
}

resource "aws_internet_gateway" "kubernetes" {
  vpc_id = "${aws_vpc.kubernetes.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.kubernetes.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.kubernetes.id}"
}