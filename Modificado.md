
<a name="readme-top"></a>



<br />
<div align="center">
  <a href="https://github.com/seu-username/"Infraestrutura-de-Instância-EC2-com-Terraform">
  </a>

<h3 align="center">Infraestrutura de Instância EC2 com Terraform</h3>

  <p align="center">
    Modificação e Melhoria do Código Terraform. 
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Sumário</summary>
  <ol>
    <li><a href="#variaveis">Variáveis</a></li>
    <li><a href="#criptografia">Criptografia SSH</a></li>
    <li><a href="#logs">Logs</a></li>
    <li><a href="#vpc-e-rede">VPC e Rede</a></li>
    <li><a href="#grupo-de-segurança">Grupo de Segurança</a></li>
    <li><a href="#nginx">Nginx</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## Sobre o Projeto

Este projeto Terraform cria uma infraestrutura básica na AWS, incluindo uma VPC, subnet pública, Internet Gateway, e uma instância EC2 executando Debian 12. É ideal para quem está começando com Terraform e AWS ou precisa de um ambiente de desenvolvimento rápido.

### Variáveis

```hcl
variable "allowed_ips" { 
  description = "IPs permitidos para acesso SSH" 
  type = list(string)
  default = [] 
}
 ```
Foi adicionada a variável "allowed_ips", que permite definir quais IPs podem acessar via SSH. Por padrão, a lista é vazia, o que exige que o usuário a defina os Ips e limite acessos indesejados, garantindo maior nível de segurança.

### Criptografia

```hcl
resource "tls_private_key" "ec2_key" {
  algorithm = "ECDSA"
  ecdsa_curve = "P256"
 ```
Foi realizada uma mudança da implementação de criptografia para a criptografia de curva elíptica (ECC - Elliptic Curve Cryptography, que é considerada mais segura e eficiente do que RSA para o mesmo tamanho de chave. 
As operações com ECC são geralmente mais rápidas e consomem menos recursos computacionais do que as operações equivalentes com RSA.
A maioria dos clientes SSH modernos suporta ECDSA, então não deve haver problemas significativos de compatibilidade.
Foi utilizada uma criptografia de curva P-384.

```hcl
 sed -i 's/^#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/' /etc/ssh/sshd_config
              sed -i 's/^HostKey \/etc\/ssh\/ssh_host_rsa_key/#HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config
              sed -i 's/^HostKey \/etc\/ssh\/ssh_host_ed25519_key/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/' /etc/ssh/sshd_config
 ```
O bloco acima mostra a configuração feita para que o SSH aceite apenas chaves ECDSA:
- HostKey para ECDSA: Assegura que o SSH usará a chave ECDSA para autenticação.
- Desabilitar outras chaves: Desabilita o uso de chaves RSA e Ed25519.
- Permitir apenas chave ECDSA: Certifica-se de que o SSH aceita apenas chaves ECDSA.

```hcl
 root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
   encrypted = true 
    delete_on_termination = true
  }
 ```
Essa alteração garante que o volume de armazenamento raiz (onde o sistema operacional da instância EC2 está instalado) seja protegido por criptografia.

## Logs

```hcl
resource "aws_flow_log" "vpc_flow_log" { 
vpc_id = aws_vpc.main_vpc.id 
traffic_type = "ALL" 
iam_role_arn = aws_iam_role.vpc_flow_log_role.arn 
log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn 
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" { 
name = "/aws/vpc/flow-log/${var.projeto}-${var.candidato}-${var.ambiente}" retention_in_days = 30 }
 ```
A modificação acima habilita o log de fluxo da VPC, o que permite registrar e monitorar o tráfego de rede. Isso melhora a auditoria e a segurança da rede. Os logs registram eventos relacionados ao servidor, como início e término de serviços, erros de serviço, entre outros.
Os logs de fluxo são enviados para o CloudWatch, com retenção de 30 dias.


## Grupo de Segurança

```hcl
ingress {
    description      = "SSH from allowed IPs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = length(var.allowed_ips) > 0 ? var.allowed_ips : ["0.0.0.0/0"]
 ```
O bloco acima implementa SSH restrito, o acesso SSH só é permitido aos IPs especificados na variável allowed_ips. Se nenhum IP for fornecido, por padrão, permite o acesso de qualquer lugar (0.0.0.0/0).

```hcl
ingress { 
	description = "HTTP for Nginx" 
	from_port = 80 
	to_port = 80
	 protocol = "tcp" 
	cidr_blocks = ["0.0.0.0/0"] 

ingress {
 	description = "HTTPS for Nginx" 
	from_port = 443 
	to_port = 443 
	protocol = "tcp" 
	cidr_blocks = ["0.0.0.0/0"] }
 ```
Acima, regras de entrada foram incluídas para permitir tráfego HTTP (porta 80) e HTTPS (porta 443), visando suportar o servidor web Nginx.

``hcl
 egress {
    description      = ""Allow only necessary outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
 ```
Assim como as regras de entrada, as regras de saída também foram alteradas. A regra de saída permite todo o tráfego, mas pode ser ajustada posteriormente para ser mais restritiva, permitindo o Outbound Traffic, que se refere ao tráfego que chega a um site ou plataforma online a partir de fontes externas.

## Nginx
```hcl
user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              apt-get install -y nginx
              echo 'server {
                  listen 80;
                  server_name localhost;
                  location / {
                      proxy_pass http://localhost:8080;
                  }
              }' > /etc/nginx/sites-available/default

              systemctl restart nginx
 ```
- O bloco acima realiza a instalação do Nginx e configuração básica do servidor, a partir de um script em bash.
- Dentro do bloco server é definido um servidor virtual no Nginx. Esse servidor lida com as requisições HTTP.
- O Nginx será configurado para ouvir conexões na porta 80, que é a porta padrão para o tráfego HTTP.
- O nome do servidor para o qual o Nginx responde é configurado pelo localhost, que refere-se à máquina local. 
- O tráfego das requisições ré redirecionado internamente na porta 8080.
- Após a criação e gravação do arquivo de configuração, o comando systemctl restart nginx recarrega o serviço Nginx para aplicar as novas configurações. 

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>
