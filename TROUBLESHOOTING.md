# VPS Installer — Troubleshooting

Guia de resolução de problemas comuns.

## 🔍 Problemas Gerais

### Script não executa: "Permission denied"

```bash
# Verifique permissões
ls -l setup-vps.sh

# Adicione permissão de execução
chmod +x setup-vps.sh

# Execute novamente
./setup-vps.sh
```

### "Domínio inválido"

```
❌ Domínio inválido. Use apenas caracteres alfanuméricos, hífens e pontos
```

**Solução:**
- Use domínios válidos: `example.com`, `api.example.com`
- Não use IP direto (precisa de domínio real)
- Não inclua `http://` ou `https://`

### "Email inválido"

```
❌ Email inválido. Use o formato usuario@dominio.com
```

**Solução:**
- Use formato válido: `admin@example.com`
- Não use emails com `+` ou caracteres especiais

---

## 🛠️ Problemas por Stack

### Traefik (Opção 1)

#### Certificado SSL não funciona

```bash
# Verifique status
docker logs traefik-traefik-1 | grep -i "cert\|acme"

# Limpe certificados antigos
sudo rm -rf ~/infra/traefik/acme.json

# Reinicie
docker compose -f ~/infra/traefik/docker-compose.yml restart
```

#### Domínio não resolve

```bash
# Verifique DNS
nslookup seu-dominio.com

# Verifique conectividade
curl -I https://seu-dominio.com

# Verifique firewall
sudo ufw status
```

---

### Chatwoot (Opção 3)

#### Erro de conexão ao banco

```bash
# Verifique se PostgreSQL está rodando
docker ps | grep chatwoot-postgres

# Verifique logs
docker logs chatwoot-postgres-1

# Reinicie
docker compose -f ~/infra/chatwoot/docker-compose.yml restart
```

#### Página branca ao acessar

```bash
# Aguarde inicialização (pode levar 2-3 minutos)
# Verifique logs de aplicação
docker logs chatwoot-chatwoot-1 -f

# Reconstrua se necessário
docker compose -f ~/infra/chatwoot/docker-compose.yml down
docker compose -f ~/infra/chatwoot/docker-compose.yml up -d
```

---

### n8n (Opção 4)

#### Workflows não executam

```bash
# Verifique conexão com banco
docker logs n8n-n8n-db-1

# Verifique API
docker logs n8n-n8n-1 -f

# Reinicie
docker compose -f ~/infra/n8n/docker-compose.yml restart
```

#### Erro: "Database connection failed"

```bash
# Recrie o volume
docker volume rm n8n_pg
docker compose -f ~/infra/n8n/docker-compose.yml down
docker compose -f ~/infra/n8n/docker-compose.yml up -d
```

---

### Odoo (Opção 13)

#### Erro 500 ao acessar

```bash
# Aguarde inicialização completa (5-10 minutos)
# Verifique logs
docker logs odoo-odoo-1 -f

# Reconstrua módulos
docker exec odoo-odoo-1 odoo --without-demo=all -d odoo -i base
```

#### Esqueci a senha admin

```bash
# Resetar via SQL (use com cautela!)
docker exec odoo-odoo-db-1 psql -U odoo odoo <<EOF
UPDATE res_users SET password = md5('new_password') WHERE id = 2;
EOF

# Novo usuário/senha: admin/new_password
```

#### Performance lenta

```bash
# Verifique recursos
docker stats odoo-odoo-1

# Aumentar limite de memória
# Editar docker-compose.yml e adicionar:
# deploy:
#   resources:
#     limits:
#       memory: 4G
```

---

### Backup (Opção 8)

#### Backup não está rodando

```bash
# Verifique cron
crontab -l | grep backup

# Execute manualmente
/usr/local/bin/backup-stack.sh

# Verifique logs
tail -50 /backups/logs/backup-*.log
```

#### Espaço em disco cheio

```bash
# Verifique uso
du -sh /backups

# Liste backups antigos
ls -lh /backups/daily

# Limpe manualmente
sudo rm -rf /backups/daily/2025-01-01  # Substitua a data

# Ou reduza retenção
# Editar: ~/infra/backup-config.txt
```

#### Erro ao fazer backup

```bash
# Verifique permissões
ls -ld /backups/daily
ls -ld /backups/logs

# Corrija se necessário
sudo chown -R root:root /backups
sudo chmod 755 /backups/daily /backups/logs
```

---

### SSH (Opção 11)

#### "Permission denied (publickey)"

```bash
# Verifique chave privada
ls -la ~/.ssh/deploy

# Corrija permissões
chmod 600 ~/.ssh/deploy

# Verifique permissões do servidor
ssh -i ~/.ssh/deploy -v deploy@IP_SERVIDOR

# Se erro de acesso, reconfigure SSH
./setup-vps.sh
# Opção: 11
```

#### "Connection refused"

```bash
# Verifique SSH está rodando
sudo systemctl status ssh

# Verifique porta
sudo ss -tlnp | grep :22

# Restart SSH
sudo systemctl restart ssh
```

---

### Restauração de Backup (Opção 12)

#### Erro: "Container não está rodando"

```bash
# Inicie o container
docker compose -f ~/infra/chatwoot/docker-compose.yml up -d

# Aguarde saúde
docker compose -f ~/infra/chatwoot/docker-compose.yml ps

# Tente restauração novamente
./setup-vps.sh
# Opção: 12
```

#### Erro de restauração SQL

```bash
# Verifique integridade do backup
ls -lh /backups/daily/2025-12-23/chatwoot_db.sql.gz

# Teste manual
gunzip -c /backups/daily/2025-12-23/chatwoot_db.sql.gz | head -20

# Se corrompido, tente outro backup
```

---

## 🔧 Problemas Gerais de Docker

### Docker daemon não responde

```bash
# Verifique status
sudo systemctl status docker

# Restart
sudo systemctl restart docker

# Se ainda não funcionar
sudo systemctl restart docker.socket
```

### Espaço de disco baixo

```bash
# Limpe containers parados
docker container prune -f

# Limpe imagens não usadas
docker image prune -f

# Limpe volumes orfãos
docker volume prune -f

# Limpeza agressiva (cuidado!)
docker system prune -a --volumes
```

### Sem espaço em /var/lib/docker

```bash
# Verifique uso
sudo du -sh /var/lib/docker/volumes/*

# Mude pasta de docker
sudo systemctl stop docker
sudo mv /var/lib/docker /mnt/docker  # Para partição com mais espaço
sudo systemctl start docker
```

---

## 📊 Monitoramento e Logs

### Ver logs de um serviço

```bash
# Logs em tempo real
docker logs -f odoo-odoo-1

# Últimas 100 linhas
docker logs odoo-odoo-1 --tail 100

# Com timestamps
docker logs odoo-odoo-1 -t

# Intervalo de tempo
docker logs odoo-odoo-1 --since 2h --until 30m
```

### Status de todos os containers

```bash
# Listar todos
docker ps -a

# Com formato customizado
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Estatísticas de uso
docker stats
```

### Verificar saúde

```bash
# Status geral
docker compose -f ~/infra/traefik/docker-compose.yml ps

# Health check específico
docker inspect odoo-odoo-1 | grep -A 5 '"Health"'
```

---

## 🆘 Quando Tudo Falha

### Reset Completo (⚠️ PERIGOSO!)

```bash
# Backup de emergência
sudo tar -czf /tmp/infra-backup-$(date +%F).tar.gz ~/infra/

# Parar tudo
docker compose -f ~/infra/*/docker-compose.yml down

# Remover volumes (PERDA DE DADOS!)
docker volume rm $(docker volume ls -q)

# Recomeçar instalação
./setup-vps.sh
```

### Coletar Logs para Suporte

```bash
# Criar bundle de diagnóstico
mkdir ~/diag
docker ps -a > ~/diag/containers.txt
docker logs traefik-traefik-1 > ~/diag/traefik.log 2>&1
docker logs odoo-odoo-1 > ~/diag/odoo.log 2>&1
tar -czf ~/diag.tar.gz ~/diag/

# Enviar para suporte
# (Remova dados sensíveis antes!)
```

---

## 📞 Obter Ajuda

1. **Verifique este documento** primeiro
2. **Consulte README.md** para uso básico
3. **Abra uma issue** no GitHub com logs
4. **Inclua:** Configuração, erro exato, passos reprodução

**Formato de Issue:**
```
**Descrição:** [Seu problema]
**Stack afetada:** [Opção X]
**Erro:**
```
[Cole erro exato aqui]
```
**Logs:**
```
[Cole logs relevantes]
```
**Configuração:**
- OS: Ubuntu 22.04
- Docker: 24.0.0
- Bash: 5.1
```
```

---

**Última atualização:** 23 de dezembro de 2025
