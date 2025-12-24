# VPS Installer

> **Instalador automatizado e profissional para VPS com múltiplas stacks em Docker**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-2.0.0-blue.svg)](CHANGELOG.md)
[![Bash](https://img.shields.io/badge/Bash-5.0+-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)

## 📖 Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Quick Start](#quick-start)
- [Documentação](#documentação)
- [Estrutura](#estrutura)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

## 🎯 Visão Geral

**VPS Installer** é um script Bash profissional que automatiza a instalação e configuração de múltiplos serviços (stacks) em uma VPS. Suporta modo interativo e automatizado (CI/CD), com backup automático configurável, SSH hardening e documentação completa.

### 📊 Destaques

- **13 Stacks** prontas para usar (Traefik, Chatwoot, Odoo, n8n, etc)
- **Modo Interativo** com menu amigável
- **Modo Não-Interativo** para CI/CD e automação
- **Backup Automático** com retenção configurável
- **Segurança** (SSH ed25519, hardening, validações)
- **Documentação Completa** incluindo troubleshooting
- **Pronto para Produção** com health checks

## ✨ Funcionalidades

### 🔧 Stacks Disponíveis

| # | Stack | Descrição | Requer |
|---|-------|-----------|--------|
| 1 | **Traefik** | Reverse proxy + HTTPS automático | Domínio |
| 2 | **Portainer** | UI para Docker | Traefik |
| 3 | **Chatwoot** | CRM/Chat multi-canal | Traefik |
| 4 | **n8n** | Workflow automation | Traefik |
| 5 | **Evolution** | API WhatsApp | Traefik |
| 6 | **evo-ai** | API com IA/LLM | Traefik |
| 7 | **Monitoramento** | Prometheus + Grafana | Traefik |
| 8 | **Backup** | Automático com agendamento | — |
| 13 | **Odoo** | ERP/CRM completo | Traefik |
| 10 | **Não-Interativo** | Automação via arquivo .env | — |
| 11 | **SSH** | Key generation + hardening | — |
| 12 | **Restore** | Restaurar backups | — |

### 🚀 Recursos

- ✅ **Modo Duplo**: Interativo (UI) + Não-Interativo (CI/CD)
- ✅ **Segurança**: Validação de inputs, SSH ed25519, hardening automático
- ✅ **Backup**: Automático com frequência configurável (horário, diário, semanal, etc)
- ✅ **Monitoramento**: Health checks em todos os serviços
- ✅ **Networking**: Redes Docker isoladas (proxy, backend)
- ✅ **HTTPS**: SSL automático com Let's Encrypt via Traefik
- ✅ **Persistência**: Volumes nomeados para dados
- ✅ **Documentação**: README, troubleshooting, contributing, estrutura

## 🏃 Quick Start

### Pré-requisitos

```bash
# Sistema
- Ubuntu 20.04+ ou Debian 11+
- 2GB RAM mínimo (4GB recomendado)
- 20GB disco disponível
- Acesso root ou sudo

# Software
- Bash 4.0+
- Docker 20.10+
- docker-compose 1.29+
```

### Instalação (5 minutos)

```bash
# 1. Download
git clone https://github.com/seu-usuario/vps-installer.git
cd vps-installer

# 2. Permissão
chmod +x setup-vps.sh

# 3. Execute
./setup-vps.sh

# 4. Escolha as stacks
# Digite: 1 3 8 (por exemplo: Traefik, Chatwoot, Backup)
```

### Modo Não-Interativo (CI/CD)

```bash
# 1. Criar arquivo
cp noninteractive.env ~/infra/noninteractive.env
nano ~/infra/noninteractive.env

# 2. Configurar variáveis
OPTIONS="1 3 8"
DOMAIN=seu-dominio.com
LETSENCRYPT_EMAIL=seu-email@dominio.com

# 3. Executar
NONINTERACTIVE=true ./setup-vps.sh
```

## 📚 Documentação

### Guias Principais

| Documento | Descrição |
|-----------|-----------|
| [README.md](README.md) | Documentação completa do projeto |
| [README_NONINTERACTIVE.md](README_NONINTERACTIVE.md) | Guia de modo não-interativo |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Resolução de problemas comuns |
| [SECURITY.md](SECURITY.md) | Políticas e boas práticas de segurança |
| [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) | Arquitetura e estrutura do projeto |
| [GIT_WORKFLOW.md](GIT_WORKFLOW.md) | Fluxo de trabalho Git |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Guia para contribuidores |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de versões |

### Tópicos Rápidos

**Instalação**
```bash
# Instalar Traefik + Chatwoot + Backup
./setup-vps.sh
# Menu: 1 3 8

# Instalar tudo
./setup-vps.sh
# Menu: 9
```

**Gerenciamento**
```bash
# Ver status
docker compose -f ~/infra/chatwoot/docker-compose.yml ps

# Ver logs
docker logs chatwoot-chatwoot-1 -f

# Restart
docker compose -f ~/infra/chatwoot/docker-compose.yml restart
```

**Backup e Restore**
```bash
# Fazer backup manualmente
/usr/local/bin/backup-stack.sh

# Ver configuração
cat ~/infra/backup-config.txt

# Restaurar
./setup-vps.sh
# Menu: 12
```

## 🏗️ Estrutura

```
vps-installer/
├── setup-vps.sh              # Script principal (1208 linhas)
├── noninteractive.env        # Template de variáveis
├── .gitignore               # Arquivos ignorados
├── LICENSE                  # MIT License
│
├── 📖 Documentação
├── README.md                # Documentação principal
├── README_NONINTERACTIVE.md # Guia de automação
├── TROUBLESHOOTING.md       # Resolução de problemas
├── SECURITY.md              # Segurança
├── PROJECT_STRUCTURE.md     # Arquitetura
├── GIT_WORKFLOW.md          # Fluxo Git
├── CONTRIBUTING.md          # Contribuições
└── CHANGELOG.md             # Histórico
```

Veja [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) para estrutura completa.

## 🔐 Segurança

### Implementado

- ✅ Validação regex para domínio e email
- ✅ Geração de senhas com openssl (entropia criptográfica)
- ✅ SSH ed25519 (256-bit) sem senha
- ✅ SSH hardening automático (disable root, password)
- ✅ Isolamento de rede Docker (proxy, backend)
- ✅ Health checks em todos os serviços
- ✅ SSL automático com Let's Encrypt
- ✅ `.env` e chaves com permissões restritivas

### Checklist de Produção

- [ ] Altere senha padrão do Odoo
- [ ] Configure credenciais fortes
- [ ] Configure firewall UFW
- [ ] Implemente certificados válidos
- [ ] Configure backups em storage externo
- [ ] Monitore logs
- [ ] Revise SECURITY.md

Veja [SECURITY.md](SECURITY.md) para detalhes.

## 🐛 Troubleshooting

### Problema Comum

```bash
# "Permission denied" ao executar script
chmod +x setup-vps.sh

# "Domínio inválido"
# Use: exemplo.com (não use http://, IP direto)

# "Container não inicia"
docker logs nome-container
```

Consulte [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para mais problemas e soluções.

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja:

1. [CONTRIBUTING.md](CONTRIBUTING.md) — Diretrizes
2. [GIT_WORKFLOW.md](GIT_WORKFLOW.md) — Fluxo de commits
3. Abra issues ou PRs para:
   - Bugs
   - Features
   - Documentação
   - Melhorias

### Desenvolvimento Rápido

```bash
# Criar feature branch
git checkout -b feature/minha-feature

# Fazer mudanças
vim setup-vps.sh
vim README.md

# Testar localmente
./setup-vps.sh

# Commit
git commit -m "feat: adiciona minha feature"

# Push e abrir PR
git push origin feature/minha-feature
```

## 📊 Estatísticas

| Métrica | Valor |
|---------|-------|
| Linhas de Código | 1,208 |
| Stacks | 13 |
| Documentação | 9 arquivos |
| Funcionalidades | 12 opções |
| Suporte Backup | 8 stacks |

## 🚀 Roadmap

### v2.0.0 ✅ (Current)
- [x] 9 stacks principais
- [x] Backup com scheduler
- [x] SSH hardening
- [x] Documentação completa

### v2.1.0 (Planejado)
- [ ] Nextcloud integration
- [ ] Email alerts para backup
- [ ] Dashboard web
- [ ] GitHub Actions CI/CD

### v3.0.0 (Futuro)
- [ ] S3/Cloud backup
- [ ] Terraform templates
- [ ] Kubernetes support
- [ ] Multi-server orchestration

## 📝 Licença

MIT License — Veja [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

- 📖 [Documentação Completa](README.md)
- 🐛 [Troubleshooting](TROUBLESHOOTING.md)
- 🔐 [Segurança](SECURITY.md)
- 💬 [Abra uma Issue](../../issues)

## 👥 Autores

Desenvolvido com ❤️ para a comunidade.

---

**VPS Installer v2.0.0** — Production Ready
**Status:** Ativo e Mantido | **Última Atualização:** 23 de dezembro de 2025

## 🎯 Próximas Etapas

1. ⭐ Star o projeto
2. 📖 Leia a documentação completa
3. 🧪 Teste em staging
4. 🚀 Deploy em produção
5. 💬 Dê feedback e contribua!

---

**[Voltar ao topo](#vps-installer)**
