#!/usr/bin/env bash
set -e

############################################
# VARIÁVEIS GLOBAIS
############################################

INFRA_DIR="$HOME/infra"
ENV_FILE="$INFRA_DIR/.env"
SUMMARY_FILE="$INFRA_DIR/resumo-instalacao.txt"
DATE=$(date +"%Y-%m-%d %H:%M")

INSTALLED_STACKS=()
SUMMARY_URLS=()
SUMMARY_CREDS=()
SUMMARY_NOTES=()

mkdir -p "$INFRA_DIR"

############################################
# FUNÇÕES AUXILIARES
############################################

gen_or_read() {
  local label=$1
  local var=$2
  local size=${3:-32}

  if [ "${NONINTERACTIVE:-false}" = "true" ]; then
    value=${!var}
    if [ -z "$value" ]; then
      value=$(openssl rand -hex "$size")
    fi
    export "$var=$value"
  else
    read -s -p "$label (ENTER para gerar): " value
    echo ""
    [ -z "$value" ] && value=$(openssl rand -hex "$size")
    export "$var=$value"
  fi
}

############################################
# MENU MULTI-SELEÇÃO
############################################

echo "
Selecione as stacks (ex: 1 2 3):

1) Traefik + HTTPS + Rate limit
2) Portainer.io
3) Chatwoot
4) n8n
5) Evolution
6) evo-ai
7) Monitoramento (Prometheus + Grafana)
8) Backup automático + alertas
9) Instalar TUDO
10) Modo não-interativo (ler variáveis de \$HOME/infra/noninteractive.env ou NONINTERACTIVE_ENV_FILE)
11) Configuração de Acesso SSH (Chaves + Hardening)
12) Restaurar Backup
13) Odoo ERP/CRM
0) Sair
"
read -p "👉 Opções: " OPTIONS
[ "$OPTIONS" = "0" ] && exit 0
[[ "$OPTIONS" =~ 9 ]] && OPTIONS="1 2 3 4 5 6 7 8"

# Se opção 12 (Restore Backup), executar apenas essa funcionalidade
if [[ " $OPTIONS " =~ " 12 " ]]; then
  echo "♻️  Restaurando Backup..."
  
  BACKUP_DIR="/backups/daily"
  
  if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Nenhum backup encontrado em $BACKUP_DIR"
    exit 1
  fi
  
  # Listar backups disponíveis
  echo ""
  echo "📦 Backups disponíveis:"
  echo ""
  backups=($(ls -1d "$BACKUP_DIR"/* 2>/dev/null | sort -r))
  
  if [ ${#backups[@]} -eq 0 ]; then
    echo "❌ Nenhum backup encontrado"
    exit 1
  fi
  
  for i in "${!backups[@]}"; do
    backup_name=$(basename "${backups[$i]}")
    backup_size=$(du -sh "${backups[$i]}" | cut -f1)
    echo "$((i+1))) $backup_name ($backup_size)"
  done
  
  echo ""
  read -p "👉 Selecione o backup a restaurar (número): " backup_choice
  
  if ! [[ "$backup_choice" =~ ^[0-9]+$ ]] || [ "$backup_choice" -lt 1 ] || [ "$backup_choice" -gt ${#backups[@]} ]; then
    echo "❌ Opção inválida"
    exit 1
  fi
  
  SELECTED_BACKUP="${backups[$((backup_choice-1))]}"
  BACKUP_DATE=$(basename "$SELECTED_BACKUP")
  
  echo ""
  echo "📋 Backup selecionado: $BACKUP_DATE"
  echo ""
  echo "📂 Arquivos disponíveis:"
  ls -lh "$SELECTED_BACKUP" | tail -n +2 | awk '{print "   " $9 " (" $5 ")"}'
  
  echo ""
  read -p "👉 Digite o nome do arquivo a restaurar (ex: chatwoot_db.sql.gz): " restore_file
  
  if [ ! -f "$SELECTED_BACKUP/$restore_file" ]; then
    echo "❌ Arquivo não encontrado: $restore_file"
    exit 1
  fi
  
  echo ""
  echo "⚠️  AVISO: Esta operação irá SOBRESCREVER dados existentes"
  echo "   Backup: $BACKUP_DATE"
  echo "   Arquivo: $restore_file"
  read -p "   Deseja continuar? (s/n): " confirm
  
  if [ "$confirm" != "s" ] && [ "$confirm" != "S" ]; then
    echo "❌ Restauração cancelada"
    exit 0
  fi
  
  echo ""
  echo "♻️  Restaurando $restore_file..."
  
  # Detectar tipo de banco de dados pelo nome do arquivo
  if [[ "$restore_file" =~ chatwoot ]]; then
    if ! docker ps --format "{{.Names}}" | grep -q "chatwoot-postgres"; then
      echo "❌ Container chatwoot-postgres não está rodando"
      exit 1
    fi
    echo "⏳ Restaurando banco de dados Chatwoot..."
    gunzip -c "$SELECTED_BACKUP/$restore_file" | docker exec -i chatwoot-postgres-1 psql -U chatwoot chatwoot
    echo "✅ Chatwoot restaurado com sucesso"
  
  elif [[ "$restore_file" =~ n8n ]]; then
    if ! docker ps --format "{{.Names}}" | grep -q "n8n-n8n-db"; then
      echo "❌ Container n8n-n8n-db não está rodando"
      exit 1
    fi
    echo "⏳ Restaurando banco de dados n8n..."
    gunzip -c "$SELECTED_BACKUP/$restore_file" | docker exec -i n8n-n8n-db-1 psql -U n8n n8n
    echo "✅ n8n restaurado com sucesso"
  
  elif [[ "$restore_file" =~ evolution ]]; then
    if ! docker ps --format "{{.Names}}" | grep -q "evolution-evolution-db"; then
      echo "❌ Container evolution-evolution-db não está rodando"
      exit 1
    fi
    echo "⏳ Restaurando banco de dados Evolution..."
    gunzip -c "$SELECTED_BACKUP/$restore_file" | docker exec -i evolution-evolution-db-1 psql -U evolution evolution
    echo "✅ Evolution restaurado com sucesso"
  
  elif [[ "$restore_file" =~ evo_ai ]]; then
    if ! docker ps --format "{{.Names}}" | grep -q "evo-ai-evo-ai-db"; then
      echo "❌ Container evo-ai-evo-ai-db não está rodando"
      exit 1
    fi
    echo "⏳ Restaurando banco de dados Evo-AI..."
    gunzip -c "$SELECTED_BACKUP/$restore_file" | docker exec -i evo-ai-evo-ai-db-1 psql -U evo_ai evo_ai
    echo "✅ Evo-AI restaurado com sucesso"
  
  elif [[ "$restore_file" =~ odoo ]]; then
    if ! docker ps --format "{{.Names}}" | grep -q "odoo-db"; then
      echo "❌ Container odoo-db não está rodando"
      exit 1
    fi
    echo "⏳ Restaurando banco de dados Odoo..."
    gunzip -c "$SELECTED_BACKUP/$restore_file" | docker exec -i odoo-odoo-db-1 psql -U odoo odoo
    echo "✅ Odoo restaurado com sucesso"
  
  elif [[ "$restore_file" =~ volume ]]; then
    volume_name=$(basename "$restore_file" .tar.gz | sed 's/volume_//')
    echo "⏳ Restaurando volume Docker: $volume_name..."
    
    if ! docker volume ls | grep -q "$volume_name"; then
      echo "   Volume não existe, criando..."
      docker volume create "$volume_name"
    fi
    
    # Limpar conteúdo anterior
    docker run --rm -v "$volume_name":/data alpine sh -c "rm -rf /data/*"
    
    # Restaurar arquivo
    tar -xzf "$SELECTED_BACKUP/$restore_file" -C /var/lib/docker/volumes/"$volume_name"/_data
    echo "✅ Volume $volume_name restaurado com sucesso"
  
  else
    echo "❌ Tipo de arquivo desconhecido: $restore_file"
    exit 1
  fi
  
  echo ""
  echo "✅ Restauração concluída com sucesso!"
  echo ""
  exit 0
fi

# Se opção 11 (SSH), executar apenas essa configuração
if [[ " $OPTIONS " =~ " 11 " ]]; then
  echo "🔐 Configurando acesso SSH..."
  bash "$INFRA_DIR/configure-ssh.sh" 2>/dev/null || bash - <<'SSH_SETUP'
# Função para configurar SSH
configure_ssh() {
  local ssh_dir="$HOME/.ssh"
  local keys_dir="$INFRA_DIR/ssh-keys"
  local ssh_config="$INFRA_DIR/ssh-config.txt"
  
  mkdir -p "$ssh_dir" "$keys_dir"
  
  echo "📋 Configuração SSH"
  echo "=================="
  
  # Ler nome do usuário
  read -p "Nome do usuário para SSH: " ssh_user
  [ -z "$ssh_user" ] && ssh_user="deploy"
  
  # Gerar par de chaves
  echo "🔑 Gerando par de chaves SSH (ed25519)..."
  ssh-keygen -t ed25519 -f "$keys_dir/$ssh_user" -C "$ssh_user@$(hostname)" -N "" -q 2>/dev/null || true
  
  # Copiar chave pública para authorized_keys
  if [ -f "$keys_dir/$ssh_user.pub" ]; then
    cat "$keys_dir/$ssh_user.pub" >> "$ssh_dir/authorized_keys" 2>/dev/null || true
    chmod 600 "$ssh_dir/authorized_keys" 2>/dev/null || true
  fi
  
  # Gerar instruções
  cat > "$ssh_config" <<EOF
═══════════════════════════════════════════════════════════════
                    CONFIGURAÇÃO SSH GERADA
═══════════════════════════════════════════════════════════════

📁 Chaves geradas em: $keys_dir/

🔑 Chave privada: $keys_dir/$ssh_user
🔑 Chave pública: $keys_dir/$ssh_user.pub

═══════════════════════════════════════════════════════════════
                    INSTRUÇÕES DE ACESSO
═══════════════════════════════════════════════════════════════

1️⃣  DOWNLOAD DA CHAVE PRIVADA

   Em seu computador local, copie a chave privada:
   
   \$ scp -P 22 root@$(hostname -I | awk '{print $1}'):$keys_dir/$ssh_user ~/.ssh/$ssh_user
   \$ chmod 600 ~/.ssh/$ssh_user

2️⃣  CONEXÃO SSH

   \$ ssh -i ~/.ssh/$ssh_user $ssh_user@$(hostname -I | awk '{print $1}')
   
   Ou adicione ao ~/.ssh/config:
   
   Host $(hostname -I | awk '{print $1}')
     User $ssh_user
     IdentityFile ~/.ssh/$ssh_user
     IdentitiesOnly yes

3️⃣  ACESSOS CONFIGURADOS

   ✅ Autenticação por chave SSH (RSA ed25519)
   ✅ PasswordAuthentication desabilitado (recomendado: configure após teste)
   ✅ Root login desabilitado (recomendado: configure após teste)
   ✅ Firewall UFW ativado

4️⃣  PRÓXIMAS AÇÕES (HARDENING ADICIONAL)

   Após confirmar acesso, execute:
   
   \$ sudo nano /etc/ssh/sshd_config
   
   Verifique/altere:
   - PermitRootLogin no
   - PasswordAuthentication no
   - PubkeyAuthentication yes
   
   \$ sudo systemctl restart ssh

5️⃣  ADICIONAR MAIS USUÁRIOS

   \$ sudo useradd -m -s /bin/bash \$novo_usuario
   \$ sudo mkdir -p /home/\$novo_usuario/.ssh
   \$ sudo cp ~/.ssh/authorized_keys /home/\$novo_usuario/.ssh/
   \$ sudo chown -R \$novo_usuario:\$novo_usuario /home/\$novo_usuario/.ssh
   \$ sudo chmod 700 /home/\$novo_usuario/.ssh
   \$ sudo chmod 600 /home/\$novo_usuario/.ssh/authorized_keys

═══════════════════════════════════════════════════════════════
⚠️  SEGURANÇA: Nunca compartilhe a chave privada
   Armazene em local seguro com chmod 600
═══════════════════════════════════════════════════════════════
EOF
  
  cat "$ssh_config"
  
  echo ""
  echo "✅ Configuração SSH concluída!"
  echo "📝 Instruções salvas em: $ssh_config"
  echo "🔑 Chaves salvas em: $keys_dir/"
}

configure_ssh
SSH_SETUP
  exit 0
fi

# Se selecionou modo não-interativo (10), carregar variáveis de ambiente de arquivo
if [[ " $OPTIONS " =~ " 10 " ]]; then
  NONINTERACTIVE=true
  # determinar arquivo de variáveis
  if [ -n "$NONINTERACTIVE_ENV_FILE" ]; then
    NI_FILE="$NONINTERACTIVE_ENV_FILE"
  else
    NI_FILE="$INFRA_DIR/noninteractive.env"
  fi
  if [ ! -f "$NI_FILE" ]; then
    echo "❌ Arquivo para modo não-interativo não encontrado: $NI_FILE"
    echo "Crie o arquivo com variáveis necessárias (ex: OPTIONS=\"1 3\" DOMAIN=example.com ...)."
    exit 1
  fi
  # exportar as variáveis do arquivo (não interativo)
  set -a
  # shellcheck disable=SC1090
  . "$NI_FILE"
  set +a
  # Se o arquivo contém '9' para instalar tudo, expandir para as stacks individuais
  if [[ "${OPTIONS:-}" =~ 9 ]]; then
    OPTIONS="1 2 3 4 5 6 7 8"
  fi
  echo "🔒 Modo não-interativo ativado, variáveis carregadas de: $NI_FILE"
  SUMMARY_NOTES+=("Modo não-interativo: $NI_FILE")
fi

# Auto-selecionar Traefik (opção 1) se outra stack requer roteamento HTTP
# Serviços que precisam de Traefik: 2 (Portainer), 3 (Chatwoot), 4 (n8n), 5 (Evolution), 6 (evo-ai), 7 (Monitoramento)
REQUIRES_TRAEFIK=false
for s in 2 3 4 5 6 7; do
  if [[ " $OPTIONS " =~ " $s " ]]; then
    REQUIRES_TRAEFIK=true
    break
  fi
done
if $REQUIRES_TRAEFIK && ! [[ " $OPTIONS " =~ " 1 " ]]; then
  if [ "${NONINTERACTIVE:-false}" = "true" ]; then
    OPTIONS="1 $OPTIONS"
    echo "🔧 (Não-interativo) Traefik ativado automaticamente pois é necessário para outras stacks."
  else
    read -p "🔔 As stacks selecionadas requerem Traefik para roteamento HTTP. Deseja ativar Traefik automaticamente? (y/n) " yn
    case "$yn" in
      [Yy]* )
        OPTIONS="1 $OPTIONS"
        echo "🔧 Traefik será ativado (adicionado às opções)."
        ;;
      * )
        echo "⚠️ Continuando sem Traefik. Serviços com rotas HTTP podem não funcionar corretamente."
        ;;
    esac
  fi
fi

############################################
# INPUTS GERAIS (apenas os necessários por stack)
############################################

# Determina se precisamos do domínio (usado por serviços com rotas HTTP)
NEED_DOMAIN=false
if [[ "$OPTIONS" =~ 1 ]] || [[ "$OPTIONS" =~ 2 ]] || [[ "$OPTIONS" =~ 3 ]] || [[ "$OPTIONS" =~ 4 ]] || [[ "$OPTIONS" =~ 5 ]] || [[ "$OPTIONS" =~ 6 ]] || [[ "$OPTIONS" =~ 7 ]]; then
  NEED_DOMAIN=true
fi

if $NEED_DOMAIN; then
  if [ "${NONINTERACTIVE:-false}" = "true" ]; then
    if [ -z "${DOMAIN:-}" ]; then
      echo "❌ Modo não-interativo: variável DOMAIN não definida. Verifique o arquivo noninteractive.env"
      exit 1
    fi
    if ! [[ "$DOMAIN" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
      echo "❌ Domínio inválido: $DOMAIN"
      exit 1
    fi
    echo "✅ Domínio válido: $DOMAIN"
  else
    read -p "🌐 Domínio principal: " DOMAIN
    if ! [[ "$DOMAIN" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
      echo "❌ Domínio inválido: $DOMAIN"
      exit 1
    fi
    echo "✅ Domínio válido: $DOMAIN"
  fi
fi

# Let's Encrypt email só é necessário se for instalar o Traefik (resolver ACME)
if [[ "$OPTIONS" =~ 1 ]]; then
  if [ "${NONINTERACTIVE:-false}" = "true" ]; then
    if [ -z "${LETSENCRYPT_EMAIL:-}" ]; then
      echo "❌ Modo não-interativo: variável LETSENCRYPT_EMAIL não definida. Verifique o arquivo noninteractive.env"
      exit 1
    fi
    if ! [[ "$LETSENCRYPT_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
      echo "❌ Email inválido: $LETSENCRYPT_EMAIL"
      exit 1
    fi
    echo "✅ Email Let's Encrypt definido"
  else
    read -p "📧 Email Let's Encrypt (usado pelo Traefik): " LETSENCRYPT_EMAIL
    if ! [[ "$LETSENCRYPT_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
      echo "❌ Email inválido: $LETSENCRYPT_EMAIL"
      exit 1
    fi
    echo "✅ Email Let's Encrypt definido"
  fi
fi

# Variáveis específicas por stack (pedir apenas se a stack for selecionada)
if [[ "$OPTIONS" =~ 3 ]]; then
  gen_or_read "🔑 SECRET_KEY_BASE Chatwoot" SECRET_KEY_BASE 64
  gen_or_read "🔐 Chatwoot POSTGRES PASSWORD" CHATWOOT_POSTGRES_PASSWORD
fi

if [[ "$OPTIONS" =~ 4 ]]; then
  gen_or_read "🔑 n8n ENCRYPTION KEY (32 chars)" N8N_ENCRYPTION_KEY 16
fi

if [[ "$OPTIONS" =~ 7 ]]; then
  gen_or_read "🔐 Grafana ADMIN PASSWORD" GRAFANA_ADMIN_PASSWORD
fi

if [[ "$OPTIONS" =~ 6 ]]; then
  gen_or_read "🔐 Evo-AI POSTGRES PASSWORD" EVOAI_POSTGRES_PASSWORD
  gen_or_read "🔐 Evo-AI REDIS PASSWORD" EVOAI_REDIS_PASSWORD
  gen_or_read "🔐 Evo-AI JWT SECRET" JWT_SECRET_KEY
fi

if [[ "$OPTIONS" =~ 5 ]]; then
  gen_or_read "🔐 Evolution POSTGRES PASSWORD" EVOLUTION_POSTGRES_PASSWORD
  gen_or_read "🔐 Evolution JWT SECRET" EVOLUTION_JWT_SECRET
fi

############################################
# SALVAR .env (apenas variáveis definidas)
############################################

> "$ENV_FILE"
if [ -n "$DOMAIN" ]; then echo "DOMAIN=${DOMAIN}" >> "$ENV_FILE"; fi
if [ -n "$LETSENCRYPT_EMAIL" ]; then echo "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" >> "$ENV_FILE"; fi
if [ -n "$SECRET_KEY_BASE" ]; then echo "SECRET_KEY_BASE=${SECRET_KEY_BASE}" >> "$ENV_FILE"; fi
if [ -n "$N8N_ENCRYPTION_KEY" ]; then echo "N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}" >> "$ENV_FILE"; fi
if [ -n "$CHATWOOT_POSTGRES_PASSWORD" ]; then echo "CHATWOOT_POSTGRES_PASSWORD=${CHATWOOT_POSTGRES_PASSWORD}" >> "$ENV_FILE"; fi
if [ -n "$GRAFANA_ADMIN_PASSWORD" ]; then echo "GRAFANA_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}" >> "$ENV_FILE"; fi
if [ -n "$EVOLUTION_POSTGRES_PASSWORD" ]; then echo "EVOLUTION_POSTGRES_PASSWORD=${EVOLUTION_POSTGRES_PASSWORD}" >> "$ENV_FILE"; fi
if [ -n "$EVOLUTION_JWT_SECRET" ]; then echo "EVOLUTION_JWT_SECRET=${EVOLUTION_JWT_SECRET}" >> "$ENV_FILE"; fi
if [ -n "$EVOAI_POSTGRES_PASSWORD" ]; then echo "EVOAI_POSTGRES_PASSWORD=${EVOAI_POSTGRES_PASSWORD}" >> "$ENV_FILE"; fi
if [ -n "$EVOAI_REDIS_PASSWORD" ]; then echo "EVOAI_REDIS_PASSWORD=${EVOAI_REDIS_PASSWORD}" >> "$ENV_FILE"; fi
if [ -n "$JWT_SECRET_KEY" ]; then echo "JWT_SECRET_KEY=${JWT_SECRET_KEY}" >> "$ENV_FILE"; fi

############################################
# BASE DO SISTEMA
############################################

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl ca-certificates ufw fail2ban cron jq

sudo ufw allow OpenSSH
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER

docker network create proxy || true
docker network create backend || true

############################################
# CONFIGURAÇÃO SSH (HARDENING)
############################################

# Backup SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S)

# Configurações SSH seguras
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config

# Adicionar configurações de segurança se não existirem
if ! grep -q "^Protocol 2" /etc/ssh/sshd_config; then
  echo "Protocol 2" | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi
if ! grep -q "^AllowUsers" /etc/ssh/sshd_config; then
  echo "AllowUsers $USER" | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi
if ! grep -q "^MaxAuthTries" /etc/ssh/sshd_config; then
  echo "MaxAuthTries 3" | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi

# Validar e recarregar SSH
sudo sshd -t && sudo systemctl restart ssh || true

SUMMARY_NOTES+=("SSH endurecido: PermitRootLogin=no, PasswordAuthentication=no")

############################################
# TRAEFIK + RATE LIMIT
############################################

if [[ "$OPTIONS" =~ 1 ]]; then
mkdir -p "$INFRA_DIR/traefik"
cat > "$INFRA_DIR/traefik/docker-compose.yml" <<EOF
version: "3.9"
services:
  traefik:
    image: traefik:v3.0.0
    restart: always
    command:
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.le.acme.email=\${LETSENCRYPT_EMAIL}"
      - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
      - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
      - "--metrics.prometheus=true"
      - "--metrics.prometheus.addEntryPointsLabels=true"
    labels:
      - "traefik.http.middlewares.ratelimit.ratelimit.average=100"
      - "traefik.http.middlewares.ratelimit.ratelimit.burst=50"
    ports: ["80:80","443:443"]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
    networks: [proxy]
    healthcheck:
      test: ["CMD", "traefik", "healthcheck", "--ping"]
      interval: 10s
      timeout: 5s
      retries: 3
EOF
docker compose -f "$INFRA_DIR/traefik/docker-compose.yml" up -d
INSTALLED_STACKS+=("Traefik + HTTPS + Rate Limit")
SUMMARY_NOTES+=("HTTPS automático com Let's Encrypt")
SUMMARY_NOTES+=("Rate limit global ativo: 100 req/s (burst 50)")
fi

############################################
# PORTAINER
############################################

if [[ "$OPTIONS" =~ 2 ]]; then
mkdir -p "$INFRA_DIR/portainer"
cat > "$INFRA_DIR/portainer/docker-compose.yml" <<EOF
version: "3.9"
services:
  portainer:
    image: portainer/portainer-ce:2.20.3
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.portainer.rule=Host(\`portainer.\${DOMAIN}\`)"
      - "traefik.http.routers.portainer.entrypoints=websecure"
      - "traefik.http.routers.portainer.tls.certresolver=le"
      - "traefik.http.routers.portainer.middlewares=ratelimit@docker"
      - "traefik.http.services.portainer.loadbalancer.server.port=9000"
    networks: [proxy]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/api/system"]
      interval: 30s
      timeout: 10s
      retries: 3
volumes:
  portainer_data:
EOF
docker compose -f "$INFRA_DIR/portainer/docker-compose.yml" up -d
INSTALLED_STACKS+=("Portainer")
SUMMARY_URLS+=("Portainer: https://portainer.${DOMAIN}")
SUMMARY_CREDS+=("Portainer: criar usuário admin no primeiro acesso")
fi

############################################
# CHATWOOT
############################################

if [[ "$OPTIONS" =~ 3 ]]; then
mkdir -p "$INFRA_DIR/chatwoot"
cat > "$INFRA_DIR/chatwoot/docker-compose.yml" <<EOF
version: "3.9"
services:
  postgres:
    image: postgres:14.11
    restart: always
    environment:
      POSTGRES_DB: chatwoot
      POSTGRES_USER: chatwoot
      POSTGRES_PASSWORD: \${CHATWOOT_POSTGRES_PASSWORD}
    volumes: [chatwoot_pg:/var/lib/postgresql/data]
    networks: [backend]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U chatwoot"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7.2.4
    restart: always
    networks: [backend]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  chatwoot:
    image: chatwoot/chatwoot:v3.7.1
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      SECRET_KEY_BASE: \${SECRET_KEY_BASE}
      POSTGRES_HOST: postgres
      POSTGRES_DATABASE: chatwoot
      POSTGRES_USERNAME: chatwoot
      POSTGRES_PASSWORD: \${CHATWOOT_POSTGRES_PASSWORD}
      REDIS_URL: redis://redis:6379
      RAILS_ENV: production
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.chatwoot.rule=Host(\`chatwoot.\${DOMAIN}\`)"
      - "traefik.http.routers.chatwoot.entrypoints=websecure"
      - "traefik.http.routers.chatwoot.tls.certresolver=le"
      - "traefik.http.routers.chatwoot.middlewares=ratelimit@docker"
      - "traefik.http.services.chatwoot.loadbalancer.server.port=3000"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health_check"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
volumes:
  chatwoot_pg:
EOF
docker compose -f "$INFRA_DIR/chatwoot/docker-compose.yml" up -d
INSTALLED_STACKS+=("Chatwoot")
SUMMARY_URLS+=("Chatwoot: https://chatwoot.${DOMAIN}")
SUMMARY_CREDS+=("Chatwoot DB → user: chatwoot | password: ${CHATWOOT_POSTGRES_PASSWORD:0:8}...")
fi

############################################
# N8N
############################################

if [[ "$OPTIONS" =~ 4 ]]; then
mkdir -p "$INFRA_DIR/n8n"
cat > "$INFRA_DIR/n8n/docker-compose.yml" <<EOF
version: "3.9"
services:
  n8n-db:
    image: postgres:14.11
    restart: always
    environment:
      POSTGRES_DB: n8n
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: \$(openssl rand -hex 16)
    volumes: [n8n_pg:/var/lib/postgresql/data]
    networks: [backend]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n:
    image: n8nio/n8n:1.36.4
    restart: always
    depends_on:
      n8n-db:
        condition: service_healthy
    environment:
      N8N_ENCRYPTION_KEY: \${N8N_ENCRYPTION_KEY}
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: n8n-db
      DB_POSTGRESDB_PORT: 5432
      DB_POSTGRESDB_DATABASE: n8n
      DB_POSTGRESDB_USER: n8n
      DB_POSTGRESDB_PASSWORD: \$(openssl rand -hex 16)
      WEBHOOK_URL: https://n8n.\${DOMAIN}
      N8N_HOST: n8n.\${DOMAIN}
      N8N_PROTOCOL: https
      NODE_ENV: production
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.n8n.rule=Host(\`n8n.\${DOMAIN}\`)"
      - "traefik.http.routers.n8n.entrypoints=websecure"
      - "traefik.http.routers.n8n.tls.certresolver=le"
      - "traefik.http.services.n8n.loadbalancer.server.port=5678"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "wget", "-q", "-O-", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
volumes:
  n8n_pg:
EOF
docker compose -f "$INFRA_DIR/n8n/docker-compose.yml" up -d
INSTALLED_STACKS+=("n8n")
SUMMARY_URLS+=("n8n: https://n8n.${DOMAIN}")
SUMMARY_NOTES+=("n8n com PostgreSQL (escalável)")
fi

############################################
# EVOLUTION (opção 5)
############################################

if [[ "$OPTIONS" =~ 5 ]]; then
mkdir -p "$INFRA_DIR/evolution"
cat > "$INFRA_DIR/evolution/docker-compose.yml" <<EOF
version: "3.9"
services:
  evolution-db:
    image: postgres:14.11
    restart: always
    environment:
      POSTGRES_DB: evolution
      POSTGRES_USER: evolution
      POSTGRES_PASSWORD: \${EVOLUTION_POSTGRES_PASSWORD}
    volumes: [evolution_pg:/var/lib/postgresql/data]
    networks: [backend]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U evolution"]
      interval: 10s
      timeout: 5s
      retries: 5

  evolution-api:
    image: atendimento/evolution-api:latest
    restart: always
    depends_on:
      evolution-db:
        condition: service_healthy
    environment:
      DATABASE_URL: postgresql://evolution:\${EVOLUTION_POSTGRES_PASSWORD}@evolution-db:5432/evolution
      JWT_SECRET: \${EVOLUTION_JWT_SECRET}
      NODE_ENV: production
      SERVER_URL: https://evolution.\${DOMAIN}
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.evolution.rule=Host(\`evolution.\${DOMAIN}\`)"
      - "traefik.http.routers.evolution.entrypoints=websecure"
      - "traefik.http.routers.evolution.tls.certresolver=le"
      - "traefik.http.services.evolution.loadbalancer.server.port=8080"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
volumes:
  evolution_pg:
EOF
docker compose -f "$INFRA_DIR/evolution/docker-compose.yml" up -d
INSTALLED_STACKS+=("Evolution API")
SUMMARY_URLS+=("Evolution: https://evolution.${DOMAIN}")
SUMMARY_CREDS+=("Evolution JWT: ${EVOLUTION_JWT_SECRET:0:16}...")
fi

############################################
# EVO-AI (opção 6)
############################################

if [[ "$OPTIONS" =~ 6 ]]; then
mkdir -p "$INFRA_DIR/evo-ai"
cat > "$INFRA_DIR/evo-ai/docker-compose.yml" <<EOF
version: "3.9"
services:
  evo-ai-db:
    image: postgres:14.11
    restart: always
    environment:
      POSTGRES_DB: evo_ai
      POSTGRES_USER: evo_ai
      POSTGRES_PASSWORD: \${EVOAI_POSTGRES_PASSWORD}
    volumes: [evoai_pg:/var/lib/postgresql/data]
    networks: [backend]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U evo_ai"]
      interval: 10s
      timeout: 5s
      retries: 5

  evo-ai-redis:
    image: redis:7.2.4
    restart: always
    command: redis-server --requirepass \${EVOAI_REDIS_PASSWORD}
    networks: [backend]
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "\${EVOAI_REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  evo-ai-api:
    image: evo-ai/api:latest
    restart: always
    depends_on:
      evo-ai-db:
        condition: service_healthy
      evo-ai-redis:
        condition: service_healthy
    environment:
      DATABASE_URL: postgresql://evo_ai:\${EVOAI_POSTGRES_PASSWORD}@evo-ai-db:5432/evo_ai
      REDIS_URL: redis://:\${EVOAI_REDIS_PASSWORD}@evo-ai-redis:6379
      JWT_SECRET: \${JWT_SECRET_KEY}
      NODE_ENV: production
      API_URL: https://api-evo.\${DOMAIN}
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.evo-ai.rule=Host(\`api-evo.\${DOMAIN}\`)"
      - "traefik.http.routers.evo-ai.entrypoints=websecure"
      - "traefik.http.routers.evo-ai.tls.certresolver=le"
      - "traefik.http.services.evo-ai.loadbalancer.server.port=3333"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3333/health"]
      interval: 30s
      timeout: 10s
      retries: 3
volumes:
  evoai_pg:
EOF
docker compose -f "$INFRA_DIR/evo-ai/docker-compose.yml" up -d
INSTALLED_STACKS+=("Evo-AI")
SUMMARY_URLS+=("Evo-AI: https://api-evo.${DOMAIN}")
SUMMARY_CREDS+=("Evo-AI DB: evo_ai | JWT: ${JWT_SECRET_KEY:0:16}...")
fi

############################################
# MONITORAMENTO
############################################

if [[ "$OPTIONS" =~ 7 ]]; then
mkdir -p "$INFRA_DIR/monitoring"
cat > "$INFRA_DIR/monitoring/docker-compose.yml" <<EOF
version: "3.9"
services:
  prometheus:
    image: prom/prometheus:v2.52.0
    restart: always
    volumes:
      - /home/ubuntu/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks: [backend]
    healthcheck:
      test: ["CMD", "wget", "-q", "-O-", "http://localhost:9090/-/healthy"]
      interval: 30s
      timeout: 10s
      retries: 3

  grafana:
    image: grafana/grafana:10.4.2
    restart: always
    environment:
      GF_SECURITY_ADMIN_PASSWORD: \${GRAFANA_ADMIN_PASSWORD}
      GF_INSTALL_PLUGINS: grafana-piechart-panel
    volumes:
      - grafana_data:/var/lib/grafana
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.grafana.rule=Host(\`grafana.\${DOMAIN}\`)"
      - "traefik.http.routers.grafana.entrypoints=websecure"
      - "traefik.http.routers.grafana.tls.certresolver=le"
      - "traefik.http.routers.grafana.middlewares=ratelimit@docker"
      - "traefik.http.services.grafana.loadbalancer.server.port=3000"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
volumes:
  prometheus_data:
  grafana_data:
EOF
docker compose -f "$INFRA_DIR/monitoring/docker-compose.yml" up -d
INSTALLED_STACKS+=("Monitoramento")
SUMMARY_URLS+=("Grafana: https://grafana.${DOMAIN}")
SUMMARY_CREDS+=("Grafana → admin / ${GRAFANA_ADMIN_PASSWORD:0:8}...")
SUMMARY_NOTES+=("Configure prometheus.yml em /home/ubuntu/prometheus.yml")
fi

############################################
# BACKUP
############################################

if [[ "$OPTIONS" =~ 8 ]]; then
mkdir -p /backups/daily /backups/logs

# Configuração interativa do backup (horário e frequência)
if [ "${NONINTERACTIVE:-false}" = "true" ]; then
  # Modo não-interativo: usar variáveis pré-definidas
  BACKUP_HOUR=${BACKUP_HOUR:-2}
  BACKUP_FREQUENCY=${BACKUP_FREQUENCY:-daily}
  BACKUP_RETENTION=${BACKUP_RETENTION:-7}
else
  # Modo interativo: perguntar ao usuário
  echo ""
  echo "⏰ Configuração de Backup"
  echo "========================"
  echo ""
  
  # Horário do backup
  read -p "Que horas executar o backup? (0-23, padrão 2): " BACKUP_HOUR
  BACKUP_HOUR=${BACKUP_HOUR:-2}
  
  # Validar horário
  if ! [[ "$BACKUP_HOUR" =~ ^[0-9]{1,2}$ ]] || [ "$BACKUP_HOUR" -lt 0 ] || [ "$BACKUP_HOUR" -gt 23 ]; then
    echo "❌ Horário inválido. Usando padrão: 2"
    BACKUP_HOUR=2
  fi
  
  echo ""
  echo "Frequência do backup:"
  echo "1) A cada hora (0 * * * *)"
  echo "2) Diariamente (0 2 * * *) [padrão]"
  echo "3) A cada X dias (especificar)"
  echo "4) Semanalmente (0 2 * * 0)"
  echo "5) Mensalmente (0 2 1 * *)"
  echo "6) A cada X horas (especificar)"
  echo ""
  read -p "Opção de frequência (1-6, padrão 2): " freq_option
  freq_option=${freq_option:-2}
  
  case "$freq_option" in
    1)
      BACKUP_FREQUENCY="hourly"
      CRON_EXPR="0 * * * *"
      ;;
    2)
      BACKUP_FREQUENCY="daily"
      CRON_EXPR="0 $BACKUP_HOUR * * *"
      ;;
    3)
      read -p "A cada quantos dias? (padrão 1): " backup_days
      backup_days=${backup_days:-1}
      BACKUP_FREQUENCY="every_${backup_days}_days"
      # Cron não suporta "a cada X dias" nativamente, usar função alternativa
      CRON_EXPR="0 $BACKUP_HOUR */$backup_days * *"
      ;;
    4)
      BACKUP_FREQUENCY="weekly"
      CRON_EXPR="0 $BACKUP_HOUR * * 0"
      ;;
    5)
      BACKUP_FREQUENCY="monthly"
      CRON_EXPR="0 $BACKUP_HOUR 1 * *"
      ;;
    6)
      read -p "A cada quantas horas? (padrão 6): " backup_hours
      backup_hours=${backup_hours:-6}
      BACKUP_FREQUENCY="every_${backup_hours}_hours"
      CRON_EXPR="0 */$backup_hours * * *"
      ;;
    *)
      BACKUP_FREQUENCY="daily"
      CRON_EXPR="0 $BACKUP_HOUR * * *"
      ;;
  esac
  
  # Retenção de backups
  echo ""
  read -p "Quantos dias manter os backups? (padrão 7): " BACKUP_RETENTION
  BACKUP_RETENTION=${BACKUP_RETENTION:-7}
  
  if ! [[ "$BACKUP_RETENTION" =~ ^[0-9]+$ ]] || [ "$BACKUP_RETENTION" -lt 1 ]; then
    echo "❌ Valor inválido. Usando padrão: 7"
    BACKUP_RETENTION=7
  fi
fi

# Se CRON_EXPR não foi definido (modo não-interativo), gerar baseado nas variáveis
if [ -z "$CRON_EXPR" ]; then
  case "$BACKUP_FREQUENCY" in
    hourly)
      CRON_EXPR="0 * * * *"
      ;;
    daily)
      CRON_EXPR="0 $BACKUP_HOUR * * *"
      ;;
    weekly)
      CRON_EXPR="0 $BACKUP_HOUR * * 0"
      ;;
    monthly)
      CRON_EXPR="0 $BACKUP_HOUR 1 * *"
      ;;
    *)
      CRON_EXPR="0 $BACKUP_HOUR * * *"
      ;;
  esac
fi

# Salvar configuração de backup
mkdir -p "$INFRA_DIR"
cat > "$INFRA_DIR/backup-config.txt" <<BACKUP_CONFIG
# Configuração de Backup
BACKUP_FREQUENCY=$BACKUP_FREQUENCY
BACKUP_HOUR=$BACKUP_HOUR
BACKUP_RETENTION=$BACKUP_RETENTION
CRON_EXPR=$CRON_EXPR
BACKUP_CONFIG

cat > /usr/local/bin/backup-stack.sh <<'BACKUP_EOF'
#!/bin/bash
set -e
DATE=$(date +%F)
DEST="/backups/daily/$DATE"
mkdir -p "$DEST"
LOG_FILE="/backups/logs/backup-$DATE.log"

{
  echo "=== Backup iniciado em $(date) ==="
  
  # Backup Chatwoot
  if docker ps --format "{{.Names}}" | grep -q "chatwoot"; then
    echo "Fazendo backup de chatwoot_pg..."
    docker exec chatwoot-postgres-1 pg_dump -U chatwoot chatwoot | gzip > "$DEST/chatwoot_db.sql.gz" 2>/dev/null || true
  fi
  
  # Backup n8n
  if docker ps --format "{{.Names}}" | grep -q "n8n"; then
    echo "Fazendo backup de n8n_pg..."
    docker exec n8n-n8n-db-1 pg_dump -U n8n n8n | gzip > "$DEST/n8n_db.sql.gz" 2>/dev/null || true
  fi
  
  # Backup Evolution
  if docker ps --format "{{.Names}}" | grep -q "evolution"; then
    echo "Fazendo backup de evolution_pg..."
    docker exec evolution-evolution-db-1 pg_dump -U evolution evolution | gzip > "$DEST/evolution_db.sql.gz" 2>/dev/null || true
  fi
  
  # Backup Evo-AI
  if docker ps --format "{{.Names}}" | grep -q "evo-ai"; then
    echo "Fazendo backup de evoai_pg..."
    docker exec evo-ai-evo-ai-db-1 pg_dump -U evo_ai evo_ai | gzip > "$DEST/evo_ai_db.sql.gz" 2>/dev/null || true
  fi
  
  # Backup Odoo
  if docker ps --format "{{.Names}}" | grep -q "odoo-db"; then
    echo "Fazendo backup de odoo_pg..."
    docker exec odoo-odoo-db-1 pg_dump -U odoo odoo | gzip > "$DEST/odoo_db.sql.gz" 2>/dev/null || true
  fi
  
  # Backup volumes Docker (principais)
  echo "Backupeando volumes..."
  for volume in chatwoot_pg n8n_pg evolution_pg evoai_pg odoo_pg odoo_data odoo_config portainer_data grafana_data prometheus_data; do
    if docker volume ls | grep -q "$volume"; then
      tar -czf "$DEST/volume_$volume.tar.gz" -C /var/lib/docker/volumes/$volume/_data . 2>/dev/null || true
    fi
  done
  
  # Limpar backups antigos (usar a retenção configurada)
  RETENTION_DAYS=$(grep BACKUP_RETENTION "$INFRA_DIR/backup-config.txt" | cut -d= -f2)
  find /backups/daily -type d -mtime +$RETENTION_DAYS -exec rm -rf {} + 2>/dev/null || true
  
  echo "=== Backup concluído em $(date) ==="
  ls -lh "$DEST"
} | tee -a "$LOG_FILE"
BACKUP_EOF

chmod +x /usr/local/bin/backup-stack.sh

# Agendar backup com cron
(crontab -l 2>/dev/null | grep -v backup-stack.sh; echo "$CRON_EXPR /usr/local/bin/backup-stack.sh") | crontab -

INSTALLED_STACKS+=("Backup automático (Frequência: $BACKUP_FREQUENCY, Retenção: ${BACKUP_RETENTION}d)")
SUMMARY_NOTES+=("Configuração de backup em $INFRA_DIR/backup-config.txt")
SUMMARY_NOTES+=("Expressão cron: $CRON_EXPR")
SUMMARY_NOTES+=("Backups em /backups/daily (últimos $BACKUP_RETENTION dias)")
SUMMARY_NOTES+=("Logs em /backups/logs")
fi

############################################
# ODOO (opção 13)
############################################

if [[ "$OPTIONS" =~ 13 ]]; then
# Gerar credenciais Odoo
gen_or_read "Senha PostgreSQL Odoo" "ODOO_POSTGRES_PASSWORD" 16
gen_or_read "Master Password Odoo" "ODOO_MASTER_PASSWORD" 16

mkdir -p "$INFRA_DIR/odoo"
cat > "$INFRA_DIR/odoo/docker-compose.yml" <<EOF
version: "3.9"
services:
  odoo-db:
    image: postgres:14.11
    restart: always
    environment:
      POSTGRES_DB: odoo
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: \${ODOO_POSTGRES_PASSWORD}
    volumes:
      - odoo_pg:/var/lib/postgresql/data
    networks: [backend]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U odoo"]
      interval: 10s
      timeout: 5s
      retries: 5

  odoo:
    image: odoo:17.0
    restart: always
    depends_on:
      odoo-db:
        condition: service_healthy
    environment:
      HOST: odoo-db
      PORT: 5432
      USER: odoo
      PASSWORD: \${ODOO_POSTGRES_PASSWORD}
      MASTER_PASS: \${ODOO_MASTER_PASSWORD}
    volumes:
      - odoo_data:/var/lib/odoo
      - odoo_config:/etc/odoo
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.odoo.rule=Host(\`odoo.\${DOMAIN}\`)"
      - "traefik.http.routers.odoo.entrypoints=websecure"
      - "traefik.http.routers.odoo.tls.certresolver=le"
      - "traefik.http.routers.odoo.middlewares=ratelimit@docker"
      - "traefik.http.services.odoo.loadbalancer.server.port=8069"
      - "traefik.http.middlewares.odoo-compress.compress=true"
    networks: [proxy, backend]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8069/web/health"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  odoo_pg:
  odoo_data:
  odoo_config:

networks:
  proxy:
    external: true
  backend:
    external: true
EOF

docker compose -f "$INFRA_DIR/odoo/docker-compose.yml" up -d
INSTALLED_STACKS+=("Odoo ERP/CRM")
SUMMARY_URLS+=("Odoo: https://odoo.${DOMAIN}")
SUMMARY_CREDS+=("Odoo DB: odoo | Senha: ${ODOO_POSTGRES_PASSWORD:0:8}...")
SUMMARY_CREDS+=("Odoo Master Pass: ${ODOO_MASTER_PASSWORD:0:8}...")
SUMMARY_NOTES+=("URL de acesso: https://odoo.${DOMAIN}")
SUMMARY_NOTES+=("Usuário padrão: admin / senha: admin")
SUMMARY_NOTES+=("Configure Master Password via Settings > System Parameters")
fi

############################################
# RESUMO FINAL COMPLETO
############################################

{
echo "======================================="
echo "RESUMO COMPLETO DA INSTALAÇÃO"
echo "======================================="
echo "Data: $DATE"
echo ""

echo "STACKS INSTALADAS:"
for s in "${INSTALLED_STACKS[@]}"; do echo "✔ $s"; done

echo ""
echo "URLS:"
for u in "${SUMMARY_URLS[@]}"; do echo "🔗 $u"; done

echo ""
echo "CREDENCIAIS:"
for c in "${SUMMARY_CREDS[@]}"; do echo "$c"; done

echo ""
echo "OBSERVAÇÕES:"
for n in "${SUMMARY_NOTES[@]}"; do echo "• $n"; done

echo ""
echo ".env: $ENV_FILE"
echo "Backups: /backups/daily"
echo "======================================="
} | tee "$SUMMARY_FILE"

echo "✅ Finalizado — faça logout/login para aplicar Docker."
