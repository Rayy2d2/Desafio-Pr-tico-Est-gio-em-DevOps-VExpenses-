<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/seu-username/terraform-aws-vpc-ec2">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Terraform AWS VPC e EC2</h3>

  <p align="center">
    Um projeto Terraform para provisionar uma VPC e uma instância EC2 na AWS
    <br />
    <a href="https://github.com/seu-username/terraform-aws-vpc-ec2"><strong>Explore a documentação »</strong></a>
    <br />
    <br />
    <a href="https://github.com/seu-username/terraform-aws-vpc-ec2">Ver Demo</a>
    ·
    <a href="https://github.com/seu-username/terraform-aws-vpc-ec2/issues">Reportar Bug</a>
    ·
    <a href="https://github.com/seu-username/terraform-aws-vpc-ec2/issues">Solicitar Feature</a>
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
    <li>
      <a href="#começando">Começando</a>
      <ul>
        <li><a href="#pré-requisitos">Pré-requisitos</a></li>
        <li><a href="#instalação">Instalação</a></li>
      </ul>
    </li>
    <li><a href="#uso">Uso</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contribuindo">Contribuindo</a></li>
    <li><a href="#licença">Licença</a></li>
    <li><a href="#contato">Contato</a></li>
    <li><a href="#reconhecimentos">Reconhecimentos</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## Sobre o Projeto

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Este projeto Terraform cria uma infraestrutura básica na AWS, incluindo uma VPC, subnet pública, Internet Gateway, e uma instância EC2 executando Debian 12. É ideal para quem está começando com Terraform e AWS ou precisa de um ambiente de desenvolvimento rápido.

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

### Construído Com

* [![Terraform][Terraform.io]][Terraform-url]
* [![AWS][AWS.com]][AWS-url]

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- GETTING STARTED -->
## Começando

Para obter uma cópia local funcionando, siga estas etapas simples.

### Pré-requisitos

* [Terraform](https://www.terraform.io/downloads.html) (versão 0.12+)
* [AWS CLI](https://aws.amazon.com/cli/) instalado e configurado
* Conta AWS com as permissões necessárias

### Instalação

1. Clone o repositório
   ```sh
   git clone https://github.com/seu-username/terraform-aws-vpc-ec2.git
   ```
2. Entre no diretório do projeto
   ```sh
   cd terraform-aws-vpc-ec2
   ```
3. Inicialize o Terraform
   ```sh
   terraform init
   ```
4. (Opcional) Crie um arquivo `terraform.tfvars` para personalizar as variáveis
   ```hcl
   projeto = "MeuProjeto"
   candidato = "MeuNome"
   ```

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- USAGE EXAMPLES -->
## Uso

1. Verifique o plano de execução
   ```sh
   terraform plan
   ```

2. Aplique as mudanças
   ```sh
   terraform apply
   ```

3. Para destruir a infraestrutura
   ```sh
   terraform destroy
   ```

Para mais exemplos, consulte a [Documentação](https://github.com/seu-username/terraform-aws-vpc-ec2/blob/main/docs/usage.md)

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [ ] Adicionar suporte para múltiplas regiões
- [ ] Implementar módulos Terraform para componentes reutilizáveis
- [ ] Adicionar configurações para banco de dados RDS
- [ ] Implementar Auto Scaling Group

Veja as [issues abertas](https://github.com/seu-username/terraform-aws-vpc-ec2/issues) para uma lista completa de features propostas (e problemas conhecidos).

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- CONTRIBUTING -->
## Contribuindo

Contribuições são o que tornam a comunidade open source um lugar incrível para aprender, inspirar e criar. Quaisquer contribuições que você fizer são **muito apreciadas**.

Se você tiver uma sugestão para melhorar isso, faça um fork do repo e crie um pull request. Você também pode simplesmente abrir uma issue com a tag "melhoria".
Não se esqueça de dar uma estrela ao projeto! Obrigado novamente!

1. Faça o Fork do Projeto
2. Crie sua Branch de Feature (`git checkout -b feature/AmazingFeature`)
3. Faça o Commit de suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Faça o Push para a Branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- LICENSE -->
## Licença

Distribuído sob a Licença MIT. Veja `LICENSE.txt` para mais informações.

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- CONTACT -->
## Contato

Seu Nome - [@seu_twitter](https://twitter.com/seu_twitter) - email@example.com

Link do Projeto: [https://github.com/seu-username/terraform-aws-vpc-ec2](https://github.com/seu-username/terraform-aws-vpc-ec2)

<p align="right">(<a href="#readme-top">voltar ao topo</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Reconhecimentos

* [Terraform Best Practices](https://www.terraform-best-practices.com/)
* [AWS Documentation](https://docs.aws.amazon.com/)
* [Terraform Registry](https://registry.terraform.io/)

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
