# 🚀 VPS Installer v2.0.1 — Guia de Deployment

**Última Atualização:** 25 de dezembro de 2025  
**Versão:** 2.0.1 (Production Ready)

---

## 📌 Visão Geral Rápida

**VPS Installer** é um toolkit profissional para provisionar stacks Docker em VPS com suporte a:

✅ **13 Stacks Prontos** (WordPress, NextCloud, Odoo, PostgreSQL, etc)  
✅ **3 Métodos de Instalação** (Brew, APT, Manual)  
✅ **Backup Automático** com retenção configurável  
✅ **SSH Hardening** com ed25519 keys  
✅ **Segurança Enterprise** (Fail2ban, UFW, SSL/TLS)

---

## 🎯 Cenários de Uso

### 1️⃣ Usuário macOS
```bash
# Instalação com Homebrew
brew install eltongomez/vps-installer/vps-installer

# Executar
vps-installer

# Escolher stack desejado no menu interativo
```

### 2️⃣ Usuário Ubuntu/Debian (com Apt)
```bash
# Adicionar repositório (quando publicado)
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys YOUR_KEY_ID
echo "deb [signed-by=/usr/share/keyrings/vps-installer.gpg] https://ppa.vps-installer.io/apt stable main" | sudo tee /etc/apt/sources.list.d/vps-installer.list

# Instalar
sudo apt update && sudo apt install vps-installer

# Executar
vps-installer
```

### 3️⃣ Usuário Linux (Manual/Git)
```bash
# Clonar repositório
git clone https://github.com/eltongomez/vps-installer.git
cd vps-installer

# Instalar direto
sudo bash setup-vps.sh

# Ou buildar pacote
sudo bash packaging/build-deb.sh
```

---

## 🏗️ Arquitetura da Solução

```
┌─────────────────────────────────────────────────────────────┐
│                    VPS INSTALLER v2.0.1                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐  ┌────────────┐ │
│  │   INSTALLATION   │  │  13 DOCKER       │  │  SECURITY  │ │
│  │   METHODS        │  │  STACKS          │  │  FEATURES  │ │
│  ├──────────────────┤  ├──────────────────┤  ├────────────┤ │
│  │ • Homebrew       │  │ • WordPress      │  │ • SSH Hard │ │
│  │ • APT/PPA        │  │ • NextCloud      │  │ • Fail2ban │ │
│  │ • Manual Build   │  │ • PostgreSQL     │  │ • UFW      │ │
│  │                  │  │ • MySQL          │  │ • SSL/TLS  │ │
│  │                  │  │ • MongoDB        │  │ • Backup   │ │
│  │                  │  │ • Redis          │  │ • Health   │ │
│  │                  │  │ • Elasticsearch  │  │ • Logs     │ │
│  │                  │  │ • GitLab         │ │            │ │
│  │                  │  │ • Gitea          │  │            │ │
│  │                  │  │ • Odoo           │  │            │ │
│  │                  │  │ • Minio          │  │            │ │
│  │                  │  │ • Docker Reg.    │  │            │ │
│  │                  │  │ • Traefik        │  │            │ │
│  └──────────────────┘  └──────────────────┘  └────────────┘ │
│                                                               │
│  ┌──────────────────────────────────────────────────────────┐│
│  │  BACKUP SYSTEM    │  AUTOMATION    │  CI/CD INTEGRATION │ │
│  ├──────────────────────────────────────────────────────────┤│
│  │ • Daily/Weekly    │ • GitHub       │ • GitHub Actions   │ │
│  │ • Retention       │   Actions      │ • Package Auto     │ │
│  │ • Compression     │ • Cron Jobs    │ • Build & Release  │ │
│  │ • Restore         │ • Health Check │ • Tag Management   │ │
│  └──────────────────────────────────────────────────────────┘│
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Instalação Detalhada por OS

### macOS (Homebrew)

**Pré-requisitos:**
- macOS 10.13+ (High Sierra ou superior)
- Homebrew instalado
- Docker Desktop

**Instalação:**
```bash
# 1. Adicionar tap (when published)
brew tap eltongomez/vps-installer

# 2. Instalar
brew install vps-installer

# 3. Verificar versão
vps-installer --version
# Output: VPS Installer v2.0.1
```

**Verificar funcionamento:**
```bash
# Listar stacks disponíveis
vps-installer list

# Ver ajuda
vps-installer --help
```

### Ubuntu 22.04 / 24.04 (APT)

**Pré-requisitos:**
- Ubuntu 20.04+
- Accesso sudo
- Docker + Docker Compose

**Instalação (Quando Publicado):**
```bash
# 1. Adicionar repositório
curl -fsSL https://apt.vps-installer.io/KEY.gpg | sudo apt-key add -
echo "deb [signed-by=/usr/share/keyrings/vps-installer.gpg] https://apt.vps-installer.io/ stable main" | sudo tee /etc/apt/sources.list.d/vps-installer.list

# 2. Atualizar índice
sudo apt update

# 3. Instalar
sudo apt install vps-installer

# 4. Verificar
vps-installer --version
```

### Debian 11 / 12 (APT)

**Pré-requisitos:**
- Debian 11+
- Accesso sudo
- Docker

**Instalação:**
```bash
# 1. Instalar dependências
sudo apt install curl ca-certificates gnupg lsb-release

# 2. Configurar repositório (mesmo do Ubuntu)
# Seguir passos do Ubuntu acima

# 3. Instalar
sudo apt install vps-installer

# 4. Verificar
vps-installer --version
```

### Manual (Qualquer Linux)

**Pré-requisitos:**
- Bash 3.2+
- Git
- Docker + Docker Compose
- jq, curl, openssl

**Instalação:**
```bash
# 1. Clonar repositório
git clone https://github.com/eltongomez/vps-installer.git
cd vps-installer

# 2. Tornar executável
chmod +x setup-vps.sh

# 3. Opção A: Executar direto
sudo ./setup-vps.sh

# 3. Opção B: Instalar em /usr/local/bin
sudo install -m 755 setup-vps.sh /usr/local/bin/vps-installer
vps-installer
```

---

## 🎮 Uso Básico

### Menu Principal
```bash
$ vps-installer

╔════════════════════════════════════════════════════════════╗
║          VPS INSTALLER v2.0.1 - Production Ready          ║
║                  Professional Stack Manager                 ║
╚════════════════════════════════════════════════════════════╝

[1] WordPress Stack          [2] NextCloud Stack
[3] PostgreSQL Database      [4] MySQL Database
[5] MongoDB NoSQL            [6] Redis Cache
[7] Elasticsearch Stack      [8] GitLab Community
[9] Gitea Lightweight        [10] Odoo 17.0
[11] Minio S3                [12] Docker Registry
[13] Traefik Reverse Proxy   [14] Configurar Backup
[15] SSH Hardening           [0] Sair

Escolha uma opção (0-15):
```

### Exemplo 1: Instalar WordPress
```bash
# 1. Executar
vps-installer

# 2. Escolher opção 1 (WordPress)
# 3. Responder questões:
# - Domínio? example.com
# - Email SSL? admin@example.com
# - Usuário WordPress? admin
# - Senha WordPress? [gerada automaticamente]

# 4. Sistema instalará:
# - nginx reverse proxy (porta 80/443)
# - wordpress container
# - mysql database
# - ssl certificate (let's encrypt)
# - backup jobs
# - health checks
```

### Exemplo 2: Ativar Backup Automático
```bash
# Executar
vps-installer

# Escolher opção 14 (Configurar Backup)
# Responder:
# - Frequência? [daily/weekly/monthly]
# - Dia da semana? [0-6, 0=domingo]
# - Hora? [00-23]
# - Retenção (dias)? [30]

# Sistema configurará:
# - Cron job automático
# - Compressão de backups
# - Retenção automática
# - Notificações (opcional)
```

---

## 🔒 Segurança & Configuração

### SSH Hardening (Obrigatório)
```bash
# Executar durante setup
vps-installer

# Escolher opção 15 (SSH Hardening)
# Sistema fará:
# - Gerar ed25519 key
# - Configurar /etc/ssh/sshd_config
# - Desabilitar password auth
# - Desabilitar root login
# - Mudar porta (opcional)
# - Reiniciar SSH daemon
```

### Firewall com UFW
```bash
# Verificar status
sudo ufw status

# Regras automáticas aplicadas:
# - 22/tcp SSH
# - 80/tcp HTTP
# - 443/tcp HTTPS
# - Outras conforme stack
```

### Fail2ban Ativo
```bash
# Verificar status
sudo systemctl status fail2ban

# Ver bans ativos
sudo fail2ban-client status
```

---

## 📊 Monitoramento

### Verificar Stacks Ativos
```bash
# Listar containers
docker ps

# Ver logs de um stack
docker logs -f vps_wordpress_1

# Estatísticas de recursos
docker stats
```

### Health Checks
```bash
# Verificar saúde de um serviço
curl -s http://localhost:8080/health | jq

# Monitorar em tempo real
watch -n 5 'docker ps --format "table {{.Names}}\t{{.Status}}"'
```

### Backup Status
```bash
# Listar backups
ls -lah /backups/

# Verificar última execução
cat /var/log/vps-installer/backup.log | tail -20

# Testar restore (em ambiente de staging)
docker exec vps_postgres_1 pg_restore < /backups/db-backup.sql
```

---

## 🔧 Troubleshooting

### Docker não inicia
```bash
# Verificar status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker

# Ver logs
sudo journalctl -u docker -n 50
```

### Porta já em uso
```bash
# Encontrar processo usando porta
sudo lsof -i :80
sudo lsof -i :443

# Matar processo (se necessário)
sudo kill -9 <PID>

# Ou mudar porta em docker-compose.yml
```

### Certificado SSL expirado
```bash
# Renovar com Let's Encrypt
sudo certbot renew

# Forçar renovação
sudo certbot renew --force-renewal
```

### Espaço em disco baixo
```bash
# Ver uso
df -h

# Limpar containers/images não usados
docker system prune -a

# Ver tamanho de backups
du -sh /backups/
```

---

## 📈 Performance

### Otimizações Recomendadas

```bash
# 1. Aumentar limites de arquivo
sudo nano /etc/security/limits.conf
# Adicionar:
# * soft nofile 65535
# * hard nofile 65535

# 2. Otimizar TCP
sudo nano /etc/sysctl.conf
# Adicionar:
# net.core.somaxconn = 65535
# net.ipv4.tcp_max_syn_backlog = 65535

# 3. Aplicar mudanças
sudo sysctl -p
```

### Monitoramento de Performance
```bash
# Top processos
ps aux --sort=-%cpu | head -10

# Memória
free -h

# I/O
iostat -x 1

# Rede
iftop
```

---

## 🔄 Atualizações

### Atualizar VPS Installer
```bash
# Via Homebrew
brew upgrade vps-installer

# Via APT
sudo apt update && sudo apt upgrade vps-installer

# Via Manual
cd /path/to/vps-installer
git pull origin main
sudo bash setup-vps.sh --update
```

### Atualizar Stacks Docker
```bash
# Dentro do diretório do stack
cd /opt/stacks/wordpress

# Pull novas imagens
docker-compose pull

# Reiniciar com novas imagens
docker-compose up -d
```

---

## 📚 Documentação Completa

| Documento | Propósito |
|-----------|-----------|
| [README.md](README.md) | Visão geral e quick start |
| [PACKAGE_MANAGERS.md](PACKAGE_MANAGERS.md) | Guia de instalação detalhado |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Resolução de problemas |
| [SECURITY.md](SECURITY.md) | Segurança e best practices |
| [GIT_WORKFLOW.md](GIT_WORKFLOW.md) | Workflow para contribuidores |
| [CHANGELOG.md](CHANGELOG.md) | Histórico de versões |
| [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) | Estrutura do projeto |

---

## 🆘 Suporte

### Reportar Bugs
```bash
# No GitHub
https://github.com/eltongomez/vps-installer/issues/new

# Com detalhes:
- Versão (vps-installer --version)
- OS (uname -a)
- Stack (qual stack)
- Logs (docker logs <container>)
```

### Comunidade
- 📧 Email: eltongslima@hotmail.com
- 🐙 GitHub: @eltongomez
- 💬 Discussions: github.com/eltongomez/vps-installer/discussions

---

## 📋 Checklist de Deployment

- [ ] Clonar/instalar VPS Installer
- [ ] Verificar Docker + Docker Compose
- [ ] Executar SSH Hardening
- [ ] Escolher e instalar primeiro stack
- [ ] Configurar domínio/SSL
- [ ] Ativar backup automático
- [ ] Testar backup & restore
- [ ] Configurar firewall
- [ ] Ativar monitoramento
- [ ] Documentar configurações
- [ ] Fazer backup inicial completo

---

## ✅ Validação Pós-Instalação

```bash
# 1. Verificar versão
vps-installer --version
# Output: VPS Installer v2.0.1

# 2. Verificar Docker
docker --version
docker-compose --version

# 3. Verificar conectividade
curl -s https://example.com

# 4. Verificar backups
ls -la /backups/

# 5. Ver containers rodando
docker ps --format "table {{.Names}}\t{{.Ports}}"

# 6. Health check
curl -s http://localhost/health
```

---

## 🎓 Próximos Passos

1. **Ler SECURITY.md** - Entender segurança
2. **Ler TROUBLESHOOTING.md** - Preparar para problemas
3. **Explorar stacks** - Tentar diferentes opções
4. **Configurar backups** - Nunca perder dados
5. **Monitorar** - Keep systems healthy
6. **Contribuir** - Melhorar o projeto

---

## 📞 Informações de Contato

**Mantenedor:** Elton Lima  
**GitHub:** @eltongomez  
**Email:** eltongslima@hotmail.com  
**Repositório:** github.com/eltongomez/vps-installer

---

**Versão:** 2.0.1  
**Status:** ✅ Production Ready  
**Última Atualização:** 25 de dezembro de 2025

🎉 **VPS Installer v2.0.1 — Ready to Deploy!**
