resource "aws_key_pair" "deployer" {
  key_name = "public-key"
  public_key = "${file("/Users/laurentgrangeau/.ssh/id_rsa.pub")}"
}