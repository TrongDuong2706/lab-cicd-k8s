resource "aws_instance" "private_node" {
  ami                    = var.ami_id
  instance_type          = var.k8s_node_instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]

  associate_public_ip_address = false
  root_block_device {
    volume_size           = 20 
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = merge(var.tags, { Name = "private-node-instance" })
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.bastion_instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_sg_id]

  associate_public_ip_address = true

  tags = merge(var.tags, { Name = "bastion-instance" })
}

resource "aws_instance" "jenkins_node" {
  ami                    = var.ami_id
  instance_type          = var.jenkins_instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  iam_instance_profile   = var.jenkins_iam_instance_profile_name

  associate_public_ip_address = false
  root_block_device {
    volume_size           = 20   # 20 GB
    volume_type           = "gp2"
    delete_on_termination = true
  }
  user_data = <<-EOF
#!/bin/bash
# Chuyển hướng toàn bộ output vào một file log để dễ debug
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "--- Bắt đầu script user_data ---"
sleep 30

# Chờ cho các tiến trình apt khác hoàn tất (cực kỳ quan trọng)
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
   echo "Chờ apt lock được giải phóng..."
   sleep 10
done

echo "--- Cập nhật package lists ---"
apt-get update -y

echo "--- Cài đặt Java (OpenJDK 17) và Curl ---"
apt-get install -y openjdk-17-jdk curl

# Kiểm tra lại Java sau khi cài đặt
if ! command -v java &> /dev/null
then
    echo "!!! LỖI: Cài đặt Java thất bại. Dừng script."
    exit 1
fi
echo "Java đã được cài đặt thành công."

echo "--- Cài đặt Jenkins ---"
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins

echo "--- Kích hoạt và khởi động dịch vụ Jenkins ---"
systemctl enable jenkins
systemctl start jenkins

echo "--- Script user_data đã hoàn tất ---"
EOF



  tags = merge(var.tags, { Name = "jenkins-instance" })

}