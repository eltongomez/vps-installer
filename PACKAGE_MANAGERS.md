# 📦 Package Manager Installation

Este documento descreve como instalar o VPS Installer através de gerenciadores de pacotes profissionais.

---

## 🍎 Homebrew (macOS)

### Instalação via Homebrew

```bash
brew tap eltongomez/vps-installer
brew install vps-installer
```

### Iniciar após instalação

```bash
vps-installer
```

### Desinstalar

```bash
brew uninstall vps-installer
brew untap eltongomez/vps-installer
```

### Atualizar para nova versão

```bash
brew upgrade vps-installer
```

---

## 🐧 Debian/Ubuntu

### Instalação via APT

#### Adicionar repositório

```bash
# Importar chave GPG
curl -fsSL https://github.com/eltongomez.gpg | sudo apt-key add -

# Adicionar repositório
echo "deb [signed-by=/etc/apt/keyrings/vps-installer.gpg] https://apt.vps-installer.io/ stable main" | \
  sudo tee /etc/apt/sources.list.d/vps-installer.list

# Atualizar índice de pacotes
sudo apt update
```

#### Instalar pacote

```bash
sudo apt install vps-installer
```

#### Iniciar após instalação

```bash
vps-installer
```

#### Desinstalar

```bash
sudo apt remove vps-installer
sudo apt-key del FINGERPRINT
sudo rm /etc/apt/sources.list.d/vps-installer.list
```

#### Atualizar para nova versão

```bash
sudo apt update
sudo apt upgrade vps-installer
```

---

## 🔧 Compilar Pacote Localmente

### Requisitos

- **Debian/Ubuntu:** `debhelper`, `dpkg-dev`, `bash`
- **macOS:** `brew` instalado

### Build Debian (.deb)

```bash
# Clonar repositório
git clone https://github.com/eltongomez/vps-installer.git
cd vps-installer

# Executar build
bash packaging/build-deb.sh

# Resultado em packaging/build/
# Instalar pacote gerado
sudo dpkg -i packaging/build/vps-installer_*.deb
```

### Criar repositório APT local

```bash
# Requisite: reprepro
sudo apt install reprepro

# Executar script
bash packaging/create-repo.sh

# Repositório criado em: packaging/repo/
```

---

## 📋 Especificações de Pacote

### Homebrew Formula

**Localização:** `Formula/vps-installer.rb`

Especificações:
- ✅ Descrição: "Professional VPS Provisioning Tool with 13 Containerized Stacks"
- ✅ Homepage: https://github.com/eltongomez/vps-installer
- ✅ Licença: MIT
- ✅ Dependências: jq, curl, openssl
- ✅ Documentação: README.md, LICENSE, CHANGELOG.md, e mais
- ✅ Testes: Validação de sintaxe bash

### Debian Control File

**Localização:** `debian/control`

Especificações:
- ✅ Seção: utils
- ✅ Prioridade: optional
- ✅ Arquitetura: all (multiplataforma)
- ✅ Dependências: bash, curl, ca-certificates, jq, openssl, docker.io
- ✅ Recomendações: docker-compose, postgresql-client, git
- ✅ Sugestões: ufw, fail2ban, cron
- ✅ Padrões Debian: 4.6.2

### Debian Changelog

**Localização:** `debian/changelog`

Formato profissional conforme Debian Policy:
- ✅ Versão com release (v2.0.1-1)
- ✅ Data e hora com timezone
- ✅ Descrição de mudanças por linha
- ✅ Assinatura do mantenedor

### Debian Copyright

**Localização:** `debian/copyright`

Formato DEP-5 profissional:
- ✅ Licença: MIT
- ✅ Copyright: Informações completas
- ✅ Texto de licença: Completo e correto

---

## 🚀 Processo de Publicação

### Para Homebrew

1. Fazer fork de `homebrew-core`
2. Submeter pull request com formula
3. Após aprovação, acessível via `brew install`

**Ou** usar tap pessoal:

```bash
# Criar tap
brew tap-new eltongomez/vps-installer

# Fazer push da formula
git -C "$(brew --repo eltongomez/vps-installer)" push
```

### Para Debian/Ubuntu (APT)

1. Preparar repositório com reprepro
2. Configurar servidor web (Nginx, Apache)
3. Fazer upload de pacotes .deb
4. Gerar índice com reprepro
5. Assinar com GPG

```bash
# Exemplo com reprepro
reprepro -b packaging/repo includedeb stable packaging/build/*.deb
```

---

## 🔐 Assinatura GPG

### Gerar chave (se não tiver)

```bash
gpg --gen-key
# Segue prompts
```

### Fazer upload para repositório

```bash
# Adicionar chave ao repositório
gpg --armor --export SEU_KEY_ID > public-key.asc

# No servidor:
gpg --import public-key.asc
```

### Configurar reprepro com assinatura

```bash
# Adicionar ao conf/distributions
SignWith: SEU_KEY_ID
```

---

## 📊 Verificação de Pacote

### Validar .deb

```bash
# Informações do pacote
dpkg -I packaging/build/vps-installer_*.deb

# Conteúdo do pacote
dpkg -c packaging/build/vps-installer_*.deb

# Instalar em teste
sudo dpkg -i packaging/build/vps-installer_*.deb
vps-installer --help
```

### Validar fórmula Homebrew

```bash
# Validar sintaxe
brew audit Formula/vps-installer.rb

# Testar instalação
brew install --build-from-source Formula/vps-installer.rb
```

---

## 🐛 Troubleshooting

### Erro ao instalar via apt

```bash
# Erro: Package not found
# Solução: Adicionar repositório corretamente
sudo apt update
sudo apt-get install -y vps-installer

# Erro: GPG key not recognized
# Solução: Importar chave
curl -fsSL https://github.com/eltongomez.gpg | sudo apt-key add -
```

### Erro ao instalar via Homebrew

```bash
# Erro: Formula not found
# Solução: Adicionar tap
brew tap eltongomez/vps-installer

# Erro: Dependencies not satisfied
# Solução: Instalar dependências
brew install jq curl openssl
```

---

## 📞 Suporte

Para problemas com pacotes:

1. Verificar logs: `sudo apt install vps-installer -v`
2. Abrir issue: https://github.com/eltongomez/vps-installer/issues
3. Incluir: versão, SO, saída de erro, logs

---

**Package Managers Supported:** Homebrew (macOS), Debian/Ubuntu (APT/PPA)
**Standards Compliance:** Debian Policy Manual 4.6.2, Homebrew Formula guidelines
**Last Updated:** 25 de dezembro de 2025
