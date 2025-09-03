resource "aws_key_pair" "mi_key" {
  key_name   = "mi_key_name"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiuFUssdtHg8Y3rWGZFCSD58hSr4IqjFVKeid9d0G3bk7w99/AOyL/C45PnFodjOtD1eMndiCd40BqagdOYtKoieqlOTlmShrvE7N2A+MeaOP4CWLx7fj2MfekecPPFRAiMUCZk51SHxFr4oqX4Qhj8BkG1cG30p9QB+stfJKT3tUGczxUB1aor9qoLmPDTfaE4iSmNDscVmqQhX9jkppdzkg2ENh5cDO2EtLlHHxIodXLgetpWjBP68r90q/gwZV69XANcTWjZiZRyDmb9nIfQiZOO5C03FoG0GmTSZkAfvZdq7M2GsQSboln44VW/ukyQKFRVVepOCIHTaqcsjhV"
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Permitir acceso SSH desde cualquier IPv4"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "SSH desde cualquier lugar"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["190.215.180.45/32"] # Permitir desde cualquier dirección IPv4
  }

  #checkov:skip=CKV_AWS_382:Ensure no security groups allow egress from 0.0.0.0:0 to port -1
  egress {
    description = "Permitir trafico de salida a cualquier lugar"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_instance" "mi_ec2" {
  #checkov:skip=CKV_AWS_8:Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted
  ami                    = "ami-012967cc5a8c9f891"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mi_key.key_name
  subnet_id              = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "MiInstancia"
  }
}