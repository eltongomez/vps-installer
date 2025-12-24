# Segurança

## 🔐 Política de Segurança

Este documento descreve as práticas de segurança e como reportar vulnerabilidades.

## 📋 Práticas de Segurança Implementadas

### Validação de Inputs
- ✅ Regex para validação de domínios
- ✅ Regex para validação de emails
- ✅ Validação de horários (0-23)
- ✅ Validação de dias de retenção

### Geração de Senhas
- ✅ Uso de `openssl rand -hex` para entropia criptográfica
- ✅ Senhas com 16-32 caracteres por padrão
- ✅ Sem senhas hardcoded no script

### Acesso SSH
- ✅ Chaves ed25519 (256-bit)
- ✅ Desabilita login via root
- ✅ Desabilita autenticação por senha
- ✅ Backup automático de `sshd_config`

### Proteção de Arquivos
- ✅ `noninteractive.env` com `chmod 600`
- ✅ Chaves SSH privadas com permissões restritivas
- ✅ `.env` não incluído no git (`.gitignore`)

### Docker Security
- ✅ Health checks em todos os serviços
- ✅ Redes isoladas (proxy, backend)
- ✅ Volumes com dados persistentes
- ✅ Variáveis de ambiente seguindo boas práticas

### Traefik/HTTPS
- ✅ SSL automático com Let's Encrypt
- ✅ Rate limiting em endpoints públicos
- ✅ Suporte a domínios válidos

## 🚨 Reportar Vulnerabilidades

**IMPORTANTE:** Não abra issues públicas para vulnerabilidades!

### Processo Responsável de Divulgação

1. **Email:** Envie detalhes para [security contact will be added]
2. **Inclua:**
   - Descrição clara da vulnerabilidade
   - Passos para reproduzir
   - Impacto potencial
   - Sugestões de correção (se houver)

3. **Prazo:** Aguarde resposta em 48 horas

## ✅ Checklist de Segurança

Antes de usar em produção:

- [ ] Altere a senha padrão do Odoo (admin/admin)
- [ ] Configure credenciais fortes em todas as stacks
- [ ] Proteja o arquivo `noninteractive.env` com `chmod 600`
- [ ] Configure firewall UFW ou similar
- [ ] Implemente certificados SSL válidos
- [ ] Configure backups em storage externo
- [ ] Monitore logs de acesso
- [ ] Atualize Docker e base images regularmente
- [ ] Configure fail2ban para proteção contra força bruta
- [ ] Revise e respeite a política de permissões

## 📚 Recursos de Segurança

### Docker Security
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Shell Script Security
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)

### SSL/TLS
- [Let's Encrypt](https://letsencrypt.org/)
- [HSTS Preload](https://hstspreload.org/)

## 🔄 Atualizações de Segurança

Mantenha seu sistema atualizado:

```bash
# Atualize Docker
sudo apt update && sudo apt upgrade -y
docker --version

# Atualize imagens
docker pull traefik:latest
docker pull postgres:14.11
docker compose up -d

# Verifique vulnerabilidades
docker scout cves --latest
```

## 📞 Contato

Para questões de segurança, entre em contato com os mantenedores do projeto.

---

**Última atualização:** 23 de dezembro de 2025
