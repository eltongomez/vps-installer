# VPS Installer — setup-vps.sh

Instalador automatizado para configurar uma VPS com múltiplas stacks de serviços containerizados.

## 📦 Recursos

- ✅ **Menu interativo** com multi-seleção de stacks
- ✅ **Modo não-interativo** para automação e CI/CD
- ✅ **Validação de inputs** (domínio, email)
- ✅ **Geração automática de senhas** (openssl)
- ✅ **Auto-seleção de Traefik** quando necessário
- ✅ **Health checks** em todos os serviços
- ✅ **Backup automático configurável** com horário e frequência personalizados
- ✅ **Resumo completo** da instalação em `~/infra/resumo-instalacao.txt`
- ✅ **Docker networks** isoladas (proxy e backend)
- ✅ **Configuração SSH** com geração de chaves e hardening
- ✅ **UFW Firewall** pré-configurado e ativado
- ✅ **Fail2ban** para proteção contra força bruta
- ✅ **Restauração de backups** com opção dedicada (opção 12)

## 🚀 Quick Start

### Execução Interativa (Padrão)

```bash
chmod +x setup-vps.sh
./setup-vps.sh
```

Escolha as stacks desejadas no menu (ex: `1 2 3`).

### Execução Não-Interativa (CI/CD)

1. Crie um arquivo `~/infra/noninteractive.env`:
```bash
OPTIONS="1 3"
DOMAIN=example.com
LETSENCRYPT_EMAIL=admin@example.com
CHATWOOT_POSTGRES_PASSWORD=senha_forte
...
```

2. Execute o script e escolha opção **10** no menu:
```bash
./setup-vps.sh
# Digite: 10
```

Veja [README_NONINTERACTIVE.md](README_NONINTERACTIVE.md) para detalhes.

## 📋 Stacks Disponíveis

| # | Stack | Descrição | Requer |
|---|-------|-----------|--------|
| 1 | **Traefik** | Reverse proxy + HTTPS + Rate limit | Domínio + Email |
| 2 | **Portainer** | UI Docker management | Domínio + Traefik |
| 3 | **Chatwoot** | CRM para atendimento | Domínio + Traefik |
| 4 | **n8n** | Workflow automation | Domínio + Traefik |
| 5 | **Evolution** | API WhatsApp | Domínio + Traefik |
| 6 | **evo-ai** | API IA/LLM | Domínio + Traefik |
| 7 | **Monitoramento** | Prometheus + Grafana | Domínio + Traefik |
| 8 | **Backup** | Dumps + volumes automáticos | — |
| 9 | **Tudo** | Instala stacks 1-8 | — |
| 10 | **Não-interativo** | Modo sem prompts | noninteractive.env |
| 11 | **SSH** | Configuração de acesso SSH | — |
| 12 | **Restore** | Restaura backups de dados | — |
| 13 | **Odoo** | ERP/CRM com módulos completos | Domínio + Traefik |
| 0 | **Sair** | Cancela execução | — |

## 📂 Estrutura de Diretórios

Após execução, a estrutura será:

```
$HOME/infra/
├── .env                              # Variáveis de ambiente
├── resumo-instalacao.txt             # Resumo da instalação
├── noninteractive.env                # (opcional) Variáveis para modo não-interativo
├── traefik/
│   └── docker-compose.yml
├── portainer/
│   └── docker-compose.yml
├── chatwoot/
│   └── docker-compose.yml
├── n8n/
│   └── docker-compose.yml
├── evolution/
│   └── docker-compose.yml
├── evo-ai/
│   └── docker-compose.yml
└── monitoring/
    └── docker-compose.yml
```

## 🔒 Segurança

- ✅ Senhas geradas com `openssl rand` (criptograficamente seguras)
- ✅ Validação de domínio e email (regex)
- ✅ Health checks impedem containers defeituosos
- ✅ Firewall configurado (ufw) permitindo apenas portas necessárias
- ✅ Fail2ban instalado para proteção contra força bruta

## 📝 Exemplos

### Instalar apenas Traefik + Chatwoot

```bash
./setup-vps.sh
# Menu: 1 3
# Domain: meusite.com
# Email: admin@meusite.com
# Senhas: pressione ENTER para gerar automaticamente
```

### Instalar Tudo

```bash
./setup-vps.sh
# Menu: 9
# Domain: meusite.com
# Email: admin@meusite.com
# ... (preenccha senhas ou pressione ENTER)
```

### Modo Não-Interativo

```bash
# 1. Criar arquivo noninteractive.env
cat > ~/infra/noninteractive.env <<EOF
OPTIONS="1 3"
DOMAIN=example.com
LETSENCRYPT_EMAIL=admin@example.com
CHATWOOT_POSTGRES_PASSWORD=senha_exemplo
SECRET_KEY_BASE=abcd1234...
EOF

# 2. Proteger arquivo
chmod 600 ~/infra/noninteractive.env

# 3. Executar
./setup-vps.sh
# Menu: 10
```

## 📊 Resumo e Logs

Após a instalação, verifique:

```bash
# Resumo completo
cat ~/infra/resumo-instalacao.txt

# Variáveis gravadas
cat ~/infra/.env

# Logs de execução
docker compose -f ~/infra/*/docker-compose.yml logs
```

## � Restaurar Backup

### Opção 12: Restaurar Backup de Banco de Dados ou Volumes

Execute a opção 12 no menu para restaurar dados a partir de backups anteriores:

```bash
./setup-vps.sh
# Menu: 12
```

**Funcionalidades:**
- ✅ Lista todos os backups disponíveis com tamanho
- ✅ Seleciona a data do backup desejado
- ✅ Mostra arquivos disponíveis no backup
- ✅ Restaura bancos de dados PostgreSQL (Chatwoot, n8n, Evolution, Evo-AI)
- ✅ Restaura volumes Docker (dados da aplicação)
- ✅ Confirmação de segurança antes de restaurar

### Como Restaurar

**1. Executar a restauração:**

```bash
./setup-vps.sh
# Selecione opção 12
```

**2. Selecionar o backup:**

```
📦 Backups disponíveis:

1) 2025-12-23 (5.2G)
2) 2025-12-22 (4.8G)
3) 2025-12-21 (5.1G)

👉 Selecione o backup a restaurar (número): 1
```

**3. Escolher o arquivo para restaurar:**

```
📂 Arquivos disponíveis:
   chatwoot_db.sql.gz (120M)
   n8n_db.sql.gz (45M)
   evolution_db.sql.gz (80M)
   volume_portainer_data.tar.gz (200M)

👉 Digite o nome do arquivo a restaurar (ex: chatwoot_db.sql.gz): chatwoot_db.sql.gz
```

**4. Confirmar a restauração:**

```
⚠️  AVISO: Esta operação irá SOBRESCREVER dados existentes
   Backup: 2025-12-23
   Arquivo: chatwoot_db.sql.gz
   Deseja continuar? (s/n): s
```

### Arquivos de Backup

**Bancos de Dados:**
- `chatwoot_db.sql.gz` — Banco de dados do Chatwoot
- `n8n_db.sql.gz` — Banco de dados do n8n
- `evolution_db.sql.gz` — Banco de dados do Evolution
- `evo_ai_db.sql.gz` — Banco de dados do Evo-AI

**Volumes Docker:**
- `volume_portainer_data.tar.gz` — Dados do Portainer
- `volume_chatwoot_pg.tar.gz` — Volume PostgreSQL do Chatwoot
- `volume_grafana_data.tar.gz` — Dados do Grafana
- `volume_prometheus_data.tar.gz` — Dados do Prometheus

### Verificar Backups Disponíveis

```bash
# Listar todos os backups
ls -lh /backups/daily

# Ver conteúdo de um backup específico
ls -lh /backups/daily/2025-12-23

# Ver logs de backup
tail -f /backups/logs/backup-*.log
```

### Backup Automático

**Opção 8** permite configurar backup automático com horário, frequência e retenção personalizados.

#### Modo Interativo

Durante a instalação, você poderá escolher:

**1. Horário de execução (0-23):**
```
Que horas executar o backup? (0-23, padrão 2): 
```

**2. Frequência:**
```
Frequência do backup:
1) A cada hora (0 * * * *)
2) Diariamente (0 2 * * *) [padrão]
3) A cada X dias (especificar)
4) Semanalmente (0 2 * * 0)
5) Mensalmente (0 2 1 * *)
6) A cada X horas (especificar)
```

**3. Retenção de backups:**
```
Quantos dias manter os backups? (padrão 7):
```

#### Opções de Frequência

| Frequência | Expressão Cron | Descrição |
|-----------|---|-----------|
| `hourly` | `0 * * * *` | Executa a cada hora |
| `daily` | `0 H * * *` | Executa uma vez por dia (H = hora escolhida) |
| `every_6_hours` | `0 */6 * * *` | Executa a cada 6 horas |
| `every_12_hours` | `0 */12 * * *` | Executa a cada 12 horas |
| `every_3_days` | `0 H */3 * *` | Executa a cada 3 dias |
| `weekly` | `0 H * * 0` | Executa semanalmente (domingo) |
| `monthly` | `0 H 1 * *` | Executa mensalmente (1º dia) |

#### Exemplos Práticos

**Backup diário às 3 da manhã, manter 30 dias:**
```bash
Frequência: 2
Horário: 3
Retenção: 30
```

**Backup a cada 6 horas, manter 14 dias:**
```bash
Frequência: 6
Horas: 6
Retenção: 14
```

**Backup semanal (domingo às 1h da manhã), manter 90 dias:**
```bash
Frequência: 4
Horário: 1
Retenção: 90
```

**Backup mensal (1º dia às 0h), manter 1 ano:**
```bash
Frequência: 5
Horário: 0
Retenção: 365
```

#### Gerenciar Backups

```bash
# Executar backup manualmente agora
/usr/local/bin/backup-stack.sh

# Ver configuração atual
cat ~/infra/backup-config.txt

# Ver agendamento do cron
crontab -l | grep backup-stack

# Modificar agendamento manualmente
crontab -e

# Ver espaço usado pelos backups
du -sh /backups

# Ver logs de backup
tail -50 /backups/logs/backup-*.log

# Limpar backups antigos manualmente
find /backups/daily -type d -mtime +7 -exec rm -rf {} +
```

#### Modo Não-Interativo

Para configurar backup em modo não-interativo, adicione ao `noninteractive.env`:

```bash
# Frequência: hourly, daily, weekly, monthly, every_X_hours, every_X_days
BACKUP_FREQUENCY=daily
BACKUP_HOUR=2
BACKUP_RETENTION=7
```

**Exemplo completo com backup:**

```bash
cat > ~/infra/noninteractive.env <<EOF
OPTIONS="1 3 8"
DOMAIN=meudominio.com
LETSENCRYPT_EMAIL=admin@meudominio.com
CHATWOOT_POSTGRES_PASSWORD=senha_forte
SECRET_KEY_BASE=chave_64_hex

# Backup: a cada 6 horas, manter 30 dias
BACKUP_FREQUENCY=daily
BACKUP_HOUR=3
BACKUP_RETENTION=30
EOF

chmod 600 ~/infra/noninteractive.env
./setup-vps.sh
# Escolha opção 10 no menu
```

#### Verificar Configuração Após Instalação

```bash
# Ver configuração aplicada
cat ~/infra/backup-config.txt

# Testar backup manualmente
/usr/local/bin/backup-stack.sh

# Ver resultado
ls -lh /backups/daily/
```

## �🛠️ Configuração SSH

### Opção 11: Gerar e Configurar Acesso SSH

Execute a opção 11 no menu para:
- Gerar par de chaves SSH (ed25519)
- Configurar `authorized_keys`
- Aplicar hardening SSH automático
- Gerar instruções de acesso

```bash
./setup-vps.sh
# Menu: 11
# Nome do usuário SSH: deploy
```

**O que é configurado automaticamente:**
- ✅ `PermitRootLogin no` — Desabilita login do root
- ✅ `PasswordAuthentication no` — Apenas chaves SSH
- ✅ `PubkeyAuthentication yes` — Autenticação por chave pública
- ✅ `X11Forwarding no` — Desabilita X11
- ✅ `MaxAuthTries 3` — Limite de tentativas
- ✅ Firewall UFW permitindo SSH

**Arquivos gerados:**
- `~/infra/ssh-keys/$user` — Chave privada
- `~/infra/ssh-keys/$user.pub` — Chave pública
- `~/infra/ssh-config.txt` — Instruções de acesso

### Acessar o Servidor

Após gerar as chaves (opção 11):

```bash
# 1. Copiar chave privada para seu local
scp -P 22 root@IP_DO_SERVIDOR:~/infra/ssh-keys/deploy ~/.ssh/deploy
chmod 600 ~/.ssh/deploy

# 2. Conectar
ssh -i ~/.ssh/deploy deploy@IP_DO_SERVIDOR

# 3. Ou adicionar ao ~/.ssh/config
cat >> ~/.ssh/config <<EOF
Host meu-servidor
  HostName IP_DO_SERVIDOR
  User deploy
  IdentityFile ~/.ssh/deploy
  IdentitiesOnly yes
EOF

# Depois:
ssh meu-servidor
```

### Adicionar Usuários Adicionais

```bash
# No servidor
sudo useradd -m -s /bin/bash novo_usuario
sudo mkdir -p /home/novo_usuario/.ssh
sudo cp ~/.ssh/authorized_keys /home/novo_usuario/.ssh/
sudo chown -R novo_usuario:novo_usuario /home/novo_usuario/.ssh
sudo chmod 700 /home/novo_usuario/.ssh
sudo chmod 600 /home/novo_usuario/.ssh/authorized_keys
```

## � Odoo ERP/CRM

### Opção 13: Instalar Odoo

Execute a opção 13 para instalar Odoo, um ERP/CRM completo com dezenas de módulos.

```bash
./setup-vps.sh
# Menu: 13
```

**O que é instalado:**
- ✅ Odoo 17.0 (versão mais recente)
- ✅ PostgreSQL 14.11 como banco de dados
- ✅ Suporte a Traefik com SSL automático
- ✅ Health checks e reinício automático
- ✅ Volumes persistentes para dados

### Acessar Odoo

Após instalação:

```bash
# URL de acesso
https://odoo.SEU_DOMINIO

# Credenciais padrão
Usuário: admin
Senha: admin
```

⚠️ **IMPORTANTE:** Altere a senha padrão imediatamente no primeiro acesso!

### Módulos Disponíveis

Odoo vem com centenas de módulos:
- **CRM** — Gestão de relacionamento com clientes
- **Sales** — Vendas e cotações
- **Purchase** — Compras e requisições
- **Inventory** — Controle de estoque
- **Accounting** — Contabilidade e fiscal
- **HR** — Recursos humanos
- **Project** — Gerenciamento de projetos
- **Service** — Gestão de serviços
- **Webshop** — E-commerce integrado
- E muitos mais...

### Configuração Inicial

**1. Criar novo banco de dados:**
```
1. Login em https://odoo.SEU_DOMINIO
2. Menu: Criar Banco de Dados
3. Escolha o nome, idioma e módulos
4. Aguarde a criação (pode levar alguns minutos)
```

**2. Backup da Master Password:**

A master password é gerada automaticamente durante instalação. Para restaurá-la:

```bash
# Ver credenciais de instalação
grep "ODOO_MASTER_PASSWORD" ~/infra/.env
```

**3. Instalar módulos adicionais:**

```bash
# Via interface web
1. Ativar Modo Desenvolvedor (Settings > Activation)
2. Apps > Buscar módulo desejado
3. Instalar

# Ou via terminal
docker exec -it odoo-odoo-1 odoo --addons-path=/mnt/extra-addons -i nome_modulo
```

### Gerenciar Odoo

```bash
# Ver logs
docker logs -f odoo-odoo-1

# Reiniciar
docker restart odoo-odoo-1

# Backup manual
docker exec odoo-odoo-db-1 pg_dump -U odoo odoo | gzip > odoo_backup_$(date +%F).sql.gz

# Restaurar backup
gunzip -c odoo_backup.sql.gz | docker exec -i odoo-odoo-db-1 psql -U odoo odoo
```

### Backup Automático

Se opção 8 (Backup) está instalada, Odoo é incluído automaticamente:

```bash
# Arquivo de backup
/backups/daily/YYYY-MM-DD/odoo_db.sql.gz
/backups/daily/YYYY-MM-DD/volume_odoo_data.tar.gz
/backups/daily/YYYY-MM-DD/volume_odoo_config.tar.gz
```

## �🛠️ Gerenciamento de Stacks

Cada stack está em seu próprio diretório com `docker-compose.yml`. Para gerenciar:

```bash
# Ver status
docker compose -f ~/infra/chatwoot/docker-compose.yml ps

# Parar
docker compose -f ~/infra/chatwoot/docker-compose.yml down

# Reiniciar
docker compose -f ~/infra/chatwoot/docker-compose.yml restart

# Logs
docker compose -f ~/infra/chatwoot/docker-compose.yml logs -f
```

## 🔄 Atualizações

Para atualizar stacks:

```bash
# Pull novas imagens
docker compose -f ~/infra/chatwoot/docker-compose.yml pull

# Reiniciar com novas imagens
docker compose -f ~/infra/chatwoot/docker-compose.yml up -d
```

## 📚 Documentação Adicional

- [Modo Não-Interativo](README_NONINTERACTIVE.md)
- [noninteractive.env (exemplo)](noninteractive.env)

## 🐛 Troubleshooting

### Traefik não inicia

```bash
docker compose -f ~/infra/traefik/docker-compose.yml logs
```

### Chatwoot em erro de conexão

```bash
docker compose -f ~/infra/chatwoot/docker-compose.yml ps
docker network ls
docker network inspect backend
```

### Limpar tudo

```bash
# ATENÇÃO: Remove todos os containers e volumes!
docker compose -f ~/infra/*/docker-compose.yml down -v
rm -rf ~/infra/*
```

## 📝 Notas

- O script usa `set -e` — para em primeiro erro
- Redes Docker: `proxy` e `backend` são criadas automaticamente
- Traefik é auto-ativado se outra stack requer HTTP routing
- Cron job para backup diário às 2 AM
- Todos os serviços estão em `restart: always`

---

**Versão:** 1.0 | **Data:** 23 de dezembro de 2025 | **Autor:** VPS Installer Team
