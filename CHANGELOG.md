# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [2.0.0] - 2025-12-23

### Adicionado
- ✨ Stack Odoo 17.0 (opção 13)
- ✨ Upgrade no sistema de backup com configuração de horário e frequência
- ✨ Opção 12: Restauração de backups com interface interativa
- ✨ Suporte a variáveis de backup em modo não-interativo
- ✨ Função `gen_or_read()` para geração/leitura de credenciais
- ✨ Auto-seleção inteligente de Traefik
- 📖 Documentação completa em README_NONINTERACTIVE.md
- 📋 Exemplo de noninteractive.env

### Melhorado
- 🔄 Refatoração do sistema de inputs condicionais por stack
- 🔐 Hardening SSH automático com ed25519
- 📊 Health checks em todos os serviços
- 📝 Documentação detalhada em README.md

### Corrigido
- 🐛 Backup de Odoo incluído na rotação automática
- 🐛 Restauração de Odoo na opção 12

## [1.0.0] - 2025-12-22

### Adicionado
- 🎯 Menu interativo com 12 opções
- 🔧 8 stacks principais (Traefik, Portainer, Chatwoot, n8n, Evolution, Evo-AI, Monitoramento, Backup)
- 🔐 Configuração SSH (opção 11) com geração de chaves ed25519
- 📝 Validação de inputs (domínio e email com regex)
- 🔄 Modo não-interativo para automação
- 💾 Sistema de backup automático com cron
- 🌐 Suporte a Traefik com SSL automático (Let's Encrypt)
- 📋 Resumo completo de instalação

---

**Versão Atual:** 2.0.0
**Data de Lançamento:** 23 de dezembro de 2025
**Compatibilidade:** Ubuntu 20.04+, Debian 11+, RHEL 8+
