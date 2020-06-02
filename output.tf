output "controller-master-public-ip" {
  value = "${aws_instance.controller-master.public_ip}"
}

output "controller-backup" {
  value = ["${aws_instance.controller-backup.*.public_ip}"]
}

output "workers" {
  value = ["${aws_instance.workers.*.public_ip}"]
}