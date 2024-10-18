
<a name="readme-top"></a>



<br />
<div align="center">
  <a href="https://github.com/seu-username/"Infraestrutura-de-Instância-EC2-com-Terraform">
  </a>

<h3 align="center">Infraestrutura de Instância EC2 com Terraform</h3>

  <p align="center">
    Este código Terraform provisiona uma instância EC2 na AWS, configurando uma VPC, subnet, grupo de segurança e uma chave SSH para acessar a instância. 
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Sumário</summary>
  <ol>
    <li>
      <a href="#sobre-o-projeto">Sobre o Projeto</a>
      <ul>
        <li><a href="#construído-com">Construído Com</a></li>
      </ul>
    </li>
    <li><a href="#configuração-do-provedor">Configuração do Provedor</a></li>
    <li><a href="#variaveis">Variáveis</a></li>
    <li><a href="#chave-ssh">Chave SSH</a></li>
    <li><a href="#vpc-e-rede">VPC e Rede</a></li>
    <li><a href="#grupo-de-segurança">Grupo de Segurança</a></li>
    <li><a href="#ami-ebian">AMI Debian</a></li>
    <li><a href="#outputs">Outputs</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## Sobre o Projeto

Este projeto Terraform cria uma infraestrutura básica na AWS, incluindo uma VPC, subnet pública, Internet Gateway, e uma instância EC2 executando Debian 12. É ideal para quem está começando com Terraform e AWS ou precisa de um ambiente de desenvolvimento rápido.

### Construído Com

* [![Terraform][Terraform.io]][Terraform-url]
* [![AWS][AWS.com]][AWS-url]


## Configuração do Provedor
```hcl
provider "aws" {
region = "us-east-1"
}
   ```

O código configura o provedor AWS para usar a região `us-east-1’(abrange o Leste dos EUA (Norte da Virgínia)) para utilizar a instancia EC2.

### Variáveis

```hcl
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
 ```
Duas variáveis são definidas, estas variáveis são usadas para nomear e personalizar recursos:
A variável “projeto” define o nome padrão do projeto. (padrão: "Vexpenses").
A variável “candidato” define o nome do candidato (padrão: "SeuNome").

### Chave SSH

```hcl
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.projeto}-${var.candidato}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}
 ```
O bloco acima cria uma nova chave SSH, que se trata de uma credencial de acesso para o protocolo de rede SSH, assegurando a comunicação remota entre máquinas em redes não seguras.
- Primeiro, é gerada uma chave privada do algorítimo de criptografia RSA de 2048 bits, através do recurso tls_private_key.
- Após isso, cria um par de chaves AWS usando a chave pública gerada, uma vez que a criptografia RSA utiliza uma chave pública e uma privada, se tratando de um modelo de criptografia assimétrica.
- O nome da chave é formado pela combinação das variáveis projeto e candidato.

## VPC e Rede

```hcl
  vresource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.projeto}-${var.candidato}-vpc"
  }
}

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

 ```
Esta seção configura a infraestrutura de rede:
- Cria uma VPC  (Virtual Private Cloud), que se trata de uma nuvem privada segura e isolada hospedada em uma nuvem pública. com CIDR (Classless Inter-Domain Routing) 10.0.0.0/16.
- É habilitado o DNS suporte na VPC, permitindo o uso do DNS internamente, para realizar ações como convertem solicitações de nomes em endereços IP.
- Configura uma subnet pública em us-east-1a, definindo o intervalo 10.0.1.0/24.
- Adiciona um Internet Gateway, para permitir que os recursos da VPC possam acessar a internet.
- Configura uma tabela de rotas para acesso à internet, permitindo o tráfego de saída da rede.
- Por fim, faz associação da tabela de rotas à subnet.


## Grupo de Segurança

```hcl
resource "aws_security_group" "main_sg" {
  name        = "${var.projeto}-${var.candidato}-sg"
  description = "Permitir SSH de qualquer lugar e todo o tráfego de saída"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entrada
  ingress {
    description      = "Allow SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Regras de saída
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-sg"
  }
}
 ```

- O recurso aws_security_group criará um grupo de segurança na AWS. O nome lógico do recurso é main_sg, e ele será referenciado no código com esse nome.
- O nome do Security Group é gerado dinamicamente a partir das variáveis var.projeto e var.candidato.
- A descrição do Security Group é utilizada para identificar a sua finalidade.
- O recurso vpc_id define em qual VPC (Virtual Private Cloud) o Security Group será criado. Aqui, está referenciado o aws_vpc.main_vpc.id, que é a ID da VPC criada anteriormente.
- Permite tráfego SSH de entrada (porta 22) de qualquer lugar, utilizando o protocolo TCP, responsável pela transmissão de dados.
- O cidr_blocks especifica os blocos de IPs que terão permissão para acessar o recurso. O valor ["0.0.0.0/0"] permite o tráfego de qualquer endereço IP externo.
- Protocol: O valor -1 indica que todos os protocolos estão permitidos (TCP, UDP, ICMP, etc.)

## AMI Debian
```hcl
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
 ```
- Este bloco de dados busca a AMI mais recente do Debian 12 de 64 bits com virtualização HVM.
- O recurso aws_ami para buscar informações sobre uma AMI.
- O recurso most_recent = true instrui o Terraform a selecionar a AMI mais recente.
- O filtro procura por AMIs que começam com "debian-12-amd64-", garantindo uma imagem Debian 12 de 64 bits.
- O filtro especifica que queremos apenas AMIs que usam virtualização HVM, tipo de virtualização recomendado pela AWS.
- owners = ["679593333241"]: Esta linha especifica o ID do proprietário da AMI. 

## Instância EC2
```hcl
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
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              EOF

  tags = {
    Name = "${var.projeto}-${var.candidato}-ec2"
  }
}
 ```
Este bloco cria uma instância EC2 com as seguintes configurações:
- Usa a AMI mais recente do Debian 12.
- Tipo de instância: t2.micro, tipo de instância do EC2 projetado para reduzir os custos de aplicativos que se beneficiam da capacidade de usar toda a performance do núcleo de forma intermitente.
- subnet_id = aws_subnet.main_subnet.id: Especifica em qual subnet a instância será lançada, baseando-se na subnet definida anteriormente no código.
- É Associado o par de chaves SSH criado anteriormente a esta instância, permitindo acesso SSH através do comando: key_name = aws_key_pair.ec2_key_pair.key_name.
- Security_groups = [aws_security_group.main_sg.name]: Associa o grupo de segurança criado anteriormente a esta instância.
- associate_public_ip_address = true: Solicita que um IP público seja atribuído à instância.
- Volume raiz de 20GB, tipo de volume GP2, O volume será excluído automaticamente quando a instância for terminada.
- Executa um script em bash, que será executado quando a instância for iniciada pela primeira vez. O script atualiza o sistema operacional.


## Outputs

```hcl
output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}
 ```
O código define dois outputs:
- `private_key`: A chave privada para acessar a instância EC2 (marcada como sensível).
- `ec2_public_ip`: O endereço IP público da instância EC2.

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/seu-username/terraform-aws-vpc-ec2.svg?style=for-the-badge
[contributors-url]: https://github.com/seu-username/terraform-aws-vpc-ec2/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/seu-username/terraform-aws-vpc-ec2.svg?style=for-the-badge
[forks-url]: https://github.com/seu-username/terraform-aws-vpc-ec2/network/members
[stars-shield]: https://img.shields.io/github/stars/seu-username/terraform-aws-vpc-ec2.svg?style=for-the-badge
[stars-url]: https://github.com/seu-username/terraform-aws-vpc-ec2/stargazers
[issues-shield]: https://img.shields.io/github/issues/seu-username/terraform-aws-vpc-ec2.svg?style=for-the-badge
[issues-url]: https://github.com/seu-username/terraform-aws-vpc-ec2/issues
[license-shield]: https://img.shields.io/github/license/seu-username/terraform-aws-vpc-ec2.svg?style=for-the-badge
[license-url]: https://github.com/seu-username/terraform-aws-vpc-ec2/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/seu-linkedin-username
[product-screenshot]: images/screenshot.png
[Terraform.io]: https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://www.terraform.io/
[AWS.com]: https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white
[AWS-url]: https://aws.amazon.com/
