# Modo Não-Interativo — setup-vps.sh

## 📋 Objetivo

Permite execução automatizada do instalador sem prompts interativos. Ideal para CI/CD, cloud-init e reprovisionamento.

---

## 🗂️ Arquivo de Variáveis

Crie um arquivo contendo as variáveis necessárias. O padrão é `~/infra/noninteractive.env`, mas você pode apontar outro via `NONINTERACTIVE_ENV_FILE`.

**Proteja o arquivo:**
```bash
chmod 600 ~/infra/noninteractive.env
```

---

## 📝 Variáveis Obrigatórias e Opcionais

| Variável | Necessária para | Tipo | Descrição |
|----------|-----------------|------|-----------|
| `OPTIONS` | Sempre | Obrigatória | Lista de stacks (ex: `"1 3"`) ou `9` para instalar tudo |
| `DOMAIN` | Stacks 1-7 | Obrigatória | Domínio principal (ex: `example.com`) |
| `LETSENCRYPT_EMAIL` | Stack 1 (Traefik) | Obrigatória | Email para ACME (ex: `admin@example.com`) |
| `CHATWOOT_POSTGRES_PASSWORD` | Stack 3 (Chatwoot) | Obrigatória | Senha PostgreSQL Chatwoot |
| `SECRET_KEY_BASE` | Stack 3 (Chatwoot) | Obrigatória | Chave secreta Chatwoot (64 hex) |
| `N8N_ENCRYPTION_KEY` | Stack 4 (n8n) | Obrigatória | Chave de encriptação n8n (32 hex) |
| `GRAFANA_ADMIN_PASSWORD` | Stack 7 (Monitoramento) | Obrigatória | Senha admin Grafana |
| `EVOLUTION_POSTGRES_PASSWORD` | Stack 5 (Evolution) | Obrigatória | Senha PostgreSQL Evolution |
| `EVOLUTION_JWT_SECRET` | Stack 5 (Evolution) | Obrigatória | JWT secret Evolution |
| `EVOAI_POSTGRES_PASSWORD` | Stack 6 (Evo-AI) | Obrigatória | Senha PostgreSQL Evo-AI |
| `EVOAI_REDIS_PASSWORD` | Stack 6 (Evo-AI) | Obrigatória | Senha Redis Evo-AI |
| `JWT_SECRET_KEY` | Stack 6 (Evo-AI) | Obrigatória | JWT secret Evo-AI |
| `ODOO_POSTGRES_PASSWORD` | Stack 13 (Odoo) | Obrigatória | Senha PostgreSQL Odoo |
| `ODOO_MASTER_PASSWORD` | Stack 13 (Odoo) | Obrigatória | Master password Odoo |
| `BACKUP_FREQUENCY` | Stack 8 (Backup) | Opcional | Frequência: `hourly`, `daily`, `weekly`, `monthly`, `every_X_hours`, `every_X_days` |
| `BACKUP_HOUR` | Stack 8 (Backup) | Opcional | Horário do backup (0-23, padrão: `2`) |
| `BACKUP_RETENTION` | Stack 8 (Backup) | Opcional | Dias de retenção (padrão: `7`) |

---

## 💾 Exemplo de `noninteractive.env`

```bash
# Stacks a instalar
OPTIONS="1 3 8"

# Domínio e email (obrigatório para stacks 1-7)
DOMAIN=meudominio.com
LETSENCRYPT_EMAIL=admin@meudominio.com

# Chatwoot
CHATWOOT_POSTGRES_PASSWORD=MuItO_sEgUrO_123!
SECRET_KEY_BASE=abcd1234567890efghijklmnopqrstuvwxyzabcd1234567890efghijklmnopqrst

# n8n
N8N_ENCRYPTION_KEY=chave32caracteres1234567890ab

# Grafana
GRAFANA_ADMIN_PASSWORD=GrAfAnA_2025!

# Evolution (se OPTIONS contém 5)
EVOLUTION_POSTGRES_PASSWORD=evolution_senha!
EVOLUTION_JWT_SECRET=jwt_secret_evolution_2025

# Evo-AI (se OPTIONS contém 6)
EVOAI_POSTGRES_PASSWORD=evoai_db_password!
EVOAI_REDIS_PASSWORD=evoai_redis_password!
JWT_SECRET_KEY=jwt_evoai_secret_2025

# Backup (se OPTIONS contém 8) - Opcional, usa padrões se não definido
BACKUP_FREQUENCY=daily
BACKUP_HOUR=2
BACKUP_RETENTION=7
```

### Opções de Frequência de Backup

**`BACKUP_FREQUENCY`** pode ser:
- `hourly` — Executa a cada hora
- `daily` — Executa uma vez por dia (padrão)
- `weekly` — Executa uma vez por semana (domingo)
- `monthly` — Executa uma vez por mês (dia 1)
- `every_6_hours` — Executa a cada 6 horas
- `every_3_days` — Executa a cada 3 dias

**`BACKUP_HOUR`** define a hora (0-23):
- `0` — Meia-noite
- `2` — 2 da manhã (padrão)
- `14` — 14h (2 da tarde)
- `23` — 23h

**`BACKUP_RETENTION`** define quantos dias manter backups:
- `7` — Mantém últimos 7 dias (padrão)
- `30` — Mantém último mês
- `90` — Mantém últimos 3 meses

### Exemplos de Configuração de Backup

**Backup diário às 3 da manhã, manter 30 dias:**
```bash
BACKUP_FREQUENCY=daily
BACKUP_HOUR=3
BACKUP_RETENTION=30
```

**Backup a cada 6 horas, manter 14 dias:**
```bash
BACKUP_FREQUENCY=every_6_hours
BACKUP_HOUR=0
BACKUP_RETENTION=14
```

**Backup semanal (domingo às 1h), manter 90 dias:**
```bash
BACKUP_FREQUENCY=weekly
BACKUP_HOUR=1
BACKUP_RETENTION=90
```

**Backup mensal (1º dia às 0h), manter 365 dias:**
```bash
BACKUP_FREQUENCY=monthly
BACKUP_HOUR=0
BACKUP_RETENTION=365
```

---

## 🚀 Como Executar

### Opção 1: Via Menu (Recomendado)

1. Crie ou edite `~/infra/noninteractive.env` com suas variáveis.
2. Execute o script normalmente:
```bash
chmod +x setup-vps.sh
./setup-vps.sh
```
3. No menu, escolha a opção **10** — "Modo não-interativo".
4. O script carregará as variáveis e prosseguirá sem prompts.

### Opção 2: Variável de Ambiente

Exporte `NONINTERACTIVE_ENV_FILE` antes de executar:
```bash
export NONINTERACTIVE_ENV_FILE=/path/para/meu_noninteractive.env
./setup-vps.sh
# escolha 10 no menu
```

---

## ✅ Validações

O script em modo não-interativo executa as mesmas validações que o modo interativo:

- ✔️ Verifica se o arquivo existe
- ✔️ Valida domínio (regex)
- ✔️ Valida email Let's Encrypt (regex)
- ✔️ Falha com erro se variável obrigatória estiver ausente
- ✔️ Auto-ativa Traefik se necessário (sem prompt)

Exemplo de erro:
```
❌ Modo não-interativo: variável LETSENCRYPT_EMAIL não definida. Verifique o arquivo noninteractive.env
```

---

## 🔐 Segurança

1. **Nunca commita `noninteractive.env` em Git públicos.**
   ```bash
   echo "noninteractive.env" >> .gitignore
   ```

2. **Proteja o arquivo com permissões restrictivas:**
   ```bash
   chmod 600 ~/infra/noninteractive.env
   ```

3. **Armazene em local seguro** ou use gerenciadores de secrets (Vault, AWS Secrets Manager, etc.).

4. **Para CI/CD**, exporte variáveis de forma segura:
   ```bash
   export CHATWOOT_POSTGRES_PASSWORD=$(aws secretsmanager get-secret-value --secret-id chatwoot-db-pass | jq -r .SecretString)
   ./setup-vps.sh
   # escolha 10 no menu
   ```

---

## 📊 Resumo da Execução

Após concluir, o script gera um resumo em `~/infra/resumo-instalacao.txt` contendo:
- Stacks instaladas
- URLs de acesso
- Credenciais
- Observações (incluindo `noninteractive.env` usado)

---

## 🐛 Troubleshooting

| Problema | Solução |
|----------|---------|
| `❌ Arquivo para modo não-interativo não encontrado` | Crie `~/infra/noninteractive.env` ou exporte `NONINTERACTIVE_ENV_FILE` |
| `❌ Email inválido` | Valide formato: `usuario@dominio.com` |
| `❌ Domínio inválido` | Use apenas caracteres alfanuméricos, hífens e pontos |
| `❌ variável XXX não definida` | Adicione a variável ao `noninteractive.env` |

---

## 📚 Referência de Stacks

| # | Stack | Descrição | Variáveis Necessárias |
|---|-------|-----------|----------------------|
| 1 | Traefik | Reverse proxy com SSL automático | `DOMAIN`, `LETSENCRYPT_EMAIL` |
| 2 | Portainer | UI para gerenciar Docker | `DOMAIN` |
| 3 | Chatwoot | CRM para atendimento | `DOMAIN`, `CHATWOOT_POSTGRES_PASSWORD`, `SECRET_KEY_BASE` |
| 4 | n8n | Automação de workflows | `DOMAIN`, `N8N_ENCRYPTION_KEY` |
| 5 | Evolution | API WhatsApp | `DOMAIN`, `EVOLUTION_POSTGRES_PASSWORD`, `EVOLUTION_JWT_SECRET` |
| 6 | Evo-AI | API IA/LLM | `DOMAIN`, `EVOAI_POSTGRES_PASSWORD`, `EVOAI_REDIS_PASSWORD`, `JWT_SECRET_KEY` |
| 7 | Monitoramento | Prometheus + Grafana | `DOMAIN`, `GRAFANA_ADMIN_PASSWORD` |
| 8 | Backup | Dumps + volumes automáticos | `BACKUP_FREQUENCY` (opt), `BACKUP_HOUR` (opt), `BACKUP_RETENTION` (opt) |
| 13 | Odoo | ERP/CRM com módulos completos | `DOMAIN`, `ODOO_POSTGRES_PASSWORD`, `ODOO_MASTER_PASSWORD` |

---

## 🎯 Próximos Passos

1. Teste com uma VM/staging antes de produção.
2. Configure monitoramento e alertas.
3. Verifique a configuração de backup em `~/infra/backup-config.txt` após instalação.
4. Configure backups em storage externo para maior segurança.
5. Documente seus customizações.

### Verificar Configuração de Backup Após Instalação

```bash
# Ver configuração aplicada
cat ~/infra/backup-config.txt

# Ver agendamento do cron
crontab -l | grep backup-stack

# Testar backup manualmente
/usr/local/bin/backup-stack.sh

# Ver logs
tail -50 /backups/logs/backup-*.log
```

---

**Versão:** 2.0 | **Data:** 23 de dezembro de 2025 | **Atualizado:** Suporte a backup configurável
