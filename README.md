● Projeto Terraform AWS VPC e EC2

Este projeto Terraform cria uma infraestrutura básica na AWS, incluindo uma VPC, subnet, Internet Gateway, e uma instância EC2 executando Debian 12.

● Recursos Criados

- VPC
- Subnet Pública
- Internet Gateway
- Tabela de Rotas
- Grupo de Segurança
- Par de Chaves EC2
- Instância EC2 Debian 12

● Pré-requisitos

- Terraform (https://www.terraform.io/downloads.html) instalado (versão 0.12+)
- Conta AWS e credenciais configuradas (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

● Uso Rápido

1. Clone este repositório
2. Navegue até o diretório do projeto
3. Execute `terraform init`
4. Execute `terraform apply`

Para instruções detalhadas, consulte [docs/usage.md](docs/usage.md).
