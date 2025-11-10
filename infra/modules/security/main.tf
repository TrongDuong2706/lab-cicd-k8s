# Security Group cho các tài nguyên Public (ví dụ: ALB / Web Server)
resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Allow HTTP and HTTPS traffic from anywhere"
  vpc_id      = var.vpc_id

  # Luật vào: HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Luật vào: HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Luật ra: Cho phép mọi traffic đi ra ngoài
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "public-sg" })
}

# Security Group cho các tài nguyên Private (ví dụ: EC2 Kubernetes / Jenkins)
resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Allow SSH and NodePort traffic from public security group"
  vpc_id      = var.vpc_id

  # Luật vào: SSH từ public-sg
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  # Luật vào: NodePort range từ public-sg
  ingress {
    from_port       = 30080
    to_port         = 30080
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }
   ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id] # Chỉ cho phép từ SG của ALB
  }

  

  # Luật ra: Cho phép mọi traffic đi ra ngoài
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "private-sg" })
}


