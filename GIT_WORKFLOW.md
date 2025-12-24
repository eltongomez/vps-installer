# Git Workflow Guide

## 🚀 Inicializar Repositório

```bash
cd /Volumes/DATA/agentes/agenda_viva_ai/vps-installer

# Inicializar Git
git init

# Configurar usuário (se não estiver feito)
git config user.name "Seu Nome"
git config user.email "seu.email@example.com"

# Adicionar remoto (substitua URL)
git remote add origin https://github.com/seu-usuario/vps-installer.git

# Criar branch principal
git branch -M main
```

## 📝 Primeiro Commit

```bash
# Adicionar todos os arquivos
git add .

# Verificar o que será commitado
git status

# Commit inicial
git commit -m "Initial commit: VPS Installer v2.0.0 - Production Ready

Features:
- 13 stacks (Traefik, Chatwoot, n8n, Evolution, Evo-AI, Odoo, etc)
- Interactive and non-interactive modes
- Automatic backup with configurable frequency
- SSH configuration with ed25519 keys
- Complete documentation and troubleshooting guide
- Security hardening included"

# Push para remoto
git push -u origin main
```

## 🌳 Estratégia de Branches

```
main
  ↑
  └─ develop (desenvolvimento ativo)
      ├─ feature/nextcloud (nova stack)
      ├─ bugfix/backup-restore (correção)
      ├─ docs/security-guide (documentação)
      └─ hotfix/odoo-password-reset (emergencial)
```

### Naming Convention

```bash
# Feature (nova funcionalidade)
git checkout -b feature/nextcloud-integration
git checkout -b feature/prometheus-alerts

# Bugfix (correção)
git checkout -b bugfix/restore-backup-odoo
git checkout -b bugfix/ssh-key-permissions

# Hotfix (emergencial)
git checkout -b hotfix/database-connection-error

# Docs (documentação)
git checkout -b docs/contributing-guide
git checkout -b docs/troubleshooting-ssh

# Refactor (refatoração)
git checkout -b refactor/simplify-credential-generation
```

## 📌 Commits Convencionais

```bash
# Feature
git commit -m "feat(odoo): add Odoo 17 ERP stack (option 13)

- Create docker-compose with PostgreSQL backend
- Implement health checks
- Add backup integration
- Include master password generation"

# Bugfix
git commit -m "fix(backup): restore Odoo database correctly

- Fix container name in restore function
- Add validation before restore
- Close #45"

# Docs
git commit -m "docs(readme): add Odoo configuration section

- Document default credentials
- Add module installation guide
- Include backup/restore examples"

# Refactor
git commit -m "refactor(auth): improve password generation function

- Extract gen_or_read logic
- Add entropy validation
- Simplify variable scoping"

# Test
git commit -m "test(backup): add restore verification

- Test all database restores
- Validate volume mounts
- Check data integrity"

# Style
git commit -m "style(script): improve code formatting

- Standardize indentation (2 spaces)
- Add comments to complex sections
- Fix shellcheck warnings"

# Chore
git commit -m "chore(deps): update docker-compose version"
```

### Tipos Válidos

```
feat:       Nova funcionalidade
fix:        Correção de bug
docs:       Documentação
style:      Formatação, missing semicolons, etc
refactor:   Refatoração sem mudança de comportamento
perf:       Melhorias de performance
test:       Testes
chore:      Dependency updates, build scripts, etc
ci:         CI/CD changes
```

## 🔀 Workflow de Pull Request

```bash
# 1. Criar branch
git checkout -b feature/nova-funcionalidade

# 2. Fazer mudanças
vim setup-vps.sh
vim README.md

# 3. Adicionar ao staging
git add setup-vps.sh README.md

# 4. Commit
git commit -m "feat: adiciona nova funcionalidade"

# 5. Push
git push origin feature/nova-funcionalidade

# 6. Criar PR no GitHub/GitLab com template:
```

### Template de PR

```markdown
## 📝 Descrição
O que esta PR faz?

## 🎯 Tipo de Mudança
- [ ] Bug fix
- [ ] Nova funcionalidade
- [ ] Breaking change
- [ ] Documentação

## 🧪 Testes Realizados
- [ ] Teste modo interativo
- [ ] Teste modo não-interativo
- [ ] Teste com noninteractive.env
- [ ] Validação de sintaxe bash

## 📋 Checklist
- [ ] Código segue padrões do projeto
- [ ] Documentação atualizada
- [ ] Sem breaking changes
- [ ] Tests passando
- [ ] CHANGELOG atualizado

## 🔗 Issues Relacionadas
Closes #123

## 📸 Screenshots (se aplicável)
```

## 🏷️ Releases e Versioning

```bash
# Criar tag para release
git tag -a v2.0.0 -m "Release v2.0.0: Production Ready

- Complete Odoo integration
- Backup scheduler improvements
- Security hardening
- Full documentation"

# Push tag
git push origin v2.0.0

# Listar tags
git tag -l

# Deletar tag (se necessário)
git tag -d v2.0.0
git push origin --delete v2.0.0
```

### Versionamento Semântico

```
v2.0.0
 │ │ └─ Patch (correções)    0.0.X
 │ └──── Minor (features)    0.X.0
 └────── Major (breaking)    X.0.0

v1.0.0: Initial release
v1.1.0: Add feature X
v1.1.1: Fix bug in feature X
v2.0.0: Odoo integration (breaking change)
```

## 📊 Histório Esperado

```
v2.0.0    Initial production release
├─ feat: add Odoo 17 ERP stack
├─ feat: implement backup scheduler
├─ feat: add SSH hardening
├─ fix: restore database correctly
├─ docs: complete documentation
└─ test: add validation tests

v1.0.0    Initial release (hypothetical)
```

## 🔐 Boas Práticas

### NÃO comitar:
- ❌ Senhas ou credenciais
- ❌ Arquivos `.env` reais
- ❌ SSH keys privadas
- ❌ Dados pessoais
- ❌ Arquivos de build temporários

### Sempre comitar:
- ✅ Código funcional testado
- ✅ Documentação atualizada
- ✅ CHANGELOG atualizado
- ✅ Exemplos/templates (`.env.example`)
- ✅ Testes e validações

## 🚀 Deployment via Git

```bash
# Em servidor de produção
cd ~/vps-installer

# Puxar versão específica
git fetch origin v2.0.0
git checkout v2.0.0

# Ou via branch
git checkout main
git pull origin main

# Executar
./setup-vps.sh
```

## 📞 Remotes Úteis

```bash
# Adicionar upstream (se forkeou)
git remote add upstream https://github.com/original-owner/vps-installer.git

# Buscar atualizações
git fetch upstream

# Rebase com upstream
git rebase upstream/main
```

---

**Guia Completo de Git para VPS Installer**
**Versão:** 2.0.0 | Data: 23 de dezembro de 2025
