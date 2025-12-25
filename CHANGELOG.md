# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [2.0.1] - 2025-12-25

### Adicionado
- ✨ Suporte a Homebrew (macOS) com fórmula profissional
- ✨ Suporte a Debian/Ubuntu com pacote .deb
- ✨ APT Repository com reprepro para distribuição
- ✨ GitHub Actions workflow para build automático de pacotes
- ✨ Scripts de build profissionais: `packaging/build-deb.sh`, `packaging/create-repo.sh`
- ✨ Debian/Ubuntu package metadata conforme Debian Policy Manual
- ✨ Homebrew formula com dependências corretas e testes
- 📖 Documentação de package managers em `packaging/README.md`
- 📖 Instruções de publicação em `packaging/publishing_instructions.md`

### Melhorado
- 🔧 Debian control file com metadados completos conforme padrões
- 🔧 Debian copyright file com formato DEP-5 profissional
- 🔧 Debian changelog com histórico detalhado
- 🔧 Formula Homebrew com instalação de documentação completa
- 📋 Estrutura de packaging conforme industry standards

### Corrigido
- 🐛 SHA256 da fórmula Homebrew (v2.0.0)
- 🐛 Dependências Debian com versões mínimas especificadas
- 🐛 Metadados do pacote Debian com URLs de repositório

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
- 🚀 GitHub Actions CI/CD com 4 workflows profissionais
- 🌐 GitHub Pages com Jekyll theme
- 📚 14 arquivos de documentação profissional (3,500+ linhas)

### Melhorado
- 🔄 Refatoração do sistema de inputs condicionais por stack
- 🔐 Hardening SSH automático com ed25519
- 📊 Health checks em todos os serviços
- 📝 Documentação detalhada em README.md
- 💼 Estrutura profissional com Git workflow

### Corrigido
- 🐛 Backup de Odoo incluído na rotação automática
- 🐛 Restauração de Odoo na opção 12
- 🐛 Permissões de sudo em GitHub Actions
- 🐛 Conflitos de Docker em GitHub Actions
- 🐛 Ações depreciadas (upload-artifact v3 → v4)

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

**Versão Atual:** 2.0.1
**Data de Lançamento:** 25 de dezembro de 2025
**Compatibilidade:** Ubuntu 20.04+, Debian 11+, RHEL 8+, macOS (Homebrew)
