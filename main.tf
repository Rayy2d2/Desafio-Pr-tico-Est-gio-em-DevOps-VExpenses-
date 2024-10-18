provider "aws" {
  region = "us-east-1"
}

variable "projeto" {
  description = "Nome do projeto"
  type        = string
  default     = "VExpenses"
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
  default     = "SeuNome"
}
variable "allowed_ips" { 
description = "IPs permitidos para acesso SSH" 
type = list(string)
default = [] 
}
## allowed_ips: Uma variável que permite definir quais IPs podem acessar via SSH. Por padrão, a lista é vazia, o que exige que o usuário a defina os Ips e limite acessos indesejados, garantindo maior nível de segurança.



resource "tls_private_key" "ec2_key" {
  algorithm = "ECDSA"
  ecdsa_curve = "P256"

## Mudança da implementação de criptografia para a criptografia de curva elíptica (ECC - Elliptic Curve Cryptography, que é considerada mais segura e eficiente do que RSA para o mesmo tamanho de chave.

}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.projeto}-${var.candidato}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.projeto}-${var.candidato}-vpc"
  }
}

resource "aws_flow_log" "vpc_flow_log" { 
vpc_id = aws_vpc.main_vpc.id 
traffic_type = "ALL" 
iam_role_arn = aws_iam_role.vpc_flow_log_role.arn 
log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn 
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" { 
name = "/aws/vpc/flow-log/${var.projeto}-${var.candidato}-${var.ambiente}" retention_in_days = 30 }
# Configuração do log de fluxo da VPC
Logs de Fluxo habilitados: Agora a VPC tem o recurso de logs de fluxo ativado, o que permite registrar e monitorar o tráfego de rede. Isso melhora a auditoria e a segurança da rede.
    • CloudWatch Log Group: Os logs de fluxo são enviados para o CloudWatch, com retenção de 30 dias, o que melhora o monitoramento da infraestrutura.

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.projeto}-${var.candidato}-subnet"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.projeto}-${var.candidato}-igw"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-route_table"
  }
}

resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id

  tags = {
    Name = "${var.projeto}-${var.candidato}-route_table_association"
  }
}

resource "aws_security_group" "main_sg" {
  name        = "${var.projeto}-${var.candidato}-sg"
  description = "Permitir SSH de qualquer lugar e todo o tráfego de saída"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entrada
  ingress {
    description      = "SSH from allowed IPs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = length(var.allowed_ips) > 0 ? var.allowed_ips : ["0.0.0.0/0"]
  }
# HTTP para Nginx 
ingress { 
	description = "HTTP for Nginx" 
	from_port = 80 
	to_port = 80
	 protocol = "tcp" 
	cidr_blocks = ["0.0.0.0/0"] }

ingress {
 	description = "HTTPS for Nginx" 
	from_port = 443 
	to_port = 443 
	protocol = "tcp" 
	cidr_blocks = ["0.0.0.0/0"] }

  # Regras de saída
  egress {
    description      = ""Allow only necessary outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-sg"
  }
}

data "aws_ami" "debian12" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "debian_ec2" {
  ami             = data.aws_ami.debian12.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.main_subnet.id
  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.main_sg.name]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
   encrypted = true # Criptografia habilitada	
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
		  apt-get install -y nginx

              # Cria um arquivo básico de configuração Nginx
              echo 'server {
                  listen 80;
                  server_name localhost;
                  location / {
                      proxy_pass http://localhost:8080; # Redireciona para um serviço interno na porta 8080, se necessário
                  }
              }' > /etc/nginx/sites-available/default

              # Reinicia o Nginx para aplicar a configuração
              systemctl restart nginx

sed -i 's/^#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/' /etc/ssh/sshd_config sed -i 's/^HostKey \/etc\/ssh\/ssh_host_rsa_key/#HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config sed -i 's/^HostKey \/etc\/ssh\/ssh_host_ed25519_key/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/' /etc/ssh/sshd_config 

Configura SSH para aceitar apenas chaves ECDSA

sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config 
# Configura apenas SSH v2

echo "Protocol 2" >> /etc/ssh/sshd_config 

# Desabilita autenticação por senha 

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config 

# Reinicia o SSH 
systemctl restart sshd
 # ... [Resto do script user_data permanece o mesmo] 
EOF

  tags = {
    Name = "${var.projeto}-${var.candidato}-ec2"
  }
}

output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}
