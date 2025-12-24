# Exemplos de Commits Convencionais

Referência prática para fazer commits seguindo as convenções do projeto.

## ✍️ Padrão Geral

```
<type>(<scope>): <subject>

<body>

<footer>
```

## 📝 Exemplos Reais

### 1️⃣ Feature - Nova Stack Odoo

```bash
git commit -m "feat(stacks): add Odoo 17 ERP integration (option 13)

- Implement docker-compose with PostgreSQL backend
- Generate credentials automatically (postgres password, master password)
- Add health checks with 30s interval
- Configure Traefik routing for HTTPS
- Include in automatic backup rotation
- Support restore via option 12
- Update all documentation"
```

### 2️⃣ Feature - Scheduler de Backup

```bash
git commit -m "feat(backup): implement configurable backup scheduler

- Allow user to choose execution frequency (hourly/daily/weekly/monthly/custom)
- Support custom time selection (0-23 hours)
- Implement retention policy (configurable days)
- Generate dynamic cron expressions
- Save configuration to backup-config.txt
- Support both interactive and non-interactive modes"
```

### 3️⃣ Bugfix - Restauração de Backup

```bash
git commit -m "fix(backup): correct Odoo database restore function

- Fix container name matching in restore logic
- Add validation before restore operations
- Improve error messages for missing containers
- Handle volume restoration correctly
- Add logging of restore progress

Fixes #45"
```

### 4️⃣ Bugfix - SSH Hardening

```bash
git commit -m "fix(ssh): improve SSH key generation and hardening

- Fix ed25519 key permissions
- Correct authorized_keys configuration
- Backup sshd_config before modifications
- Use sed correctly for config changes
- Handle file creation errors gracefully

Closes #38"
```

### 5️⃣ Documentação - Readme

```bash
git commit -m "docs(readme): add comprehensive Odoo configuration guide

- Document default admin credentials
- Add module installation instructions
- Include backup/restore examples
- Add troubleshooting section
- Update stack table with option 13"
```

### 6️⃣ Documentação - Troubleshooting

```bash
git commit -m "docs(troubleshooting): expand with Odoo common issues

- Add section for 500 errors
- Document password recovery process
- Include performance optimization tips
- Add solutions for slow initialization"
```

### 7️⃣ Refatoração - Geração de Senhas

```bash
git commit -m "refactor(core): improve gen_or_read function

- Extract validation logic to separate function
- Reduce duplicate code
- Improve variable scoping
- Add entropy verification
- Simplify conditional logic"
```

### 8️⃣ Refatoração - Menu Interativo

```bash
git commit -m "refactor(menu): simplify option handling

- Consolidate similar option checks
- Remove duplicated validation code
- Improve readability of conditionals
- Extract stack installation to functions"
```

### 9️⃣ Style - Formatação

```bash
git commit -m "style(script): standardize code formatting

- Enforce 2-space indentation
- Add missing comments to complex sections
- Fix shellcheck warnings
- Improve variable naming consistency"
```

### 🔟 Teste - Validações

```bash
git commit -m "test(validation): add input validation tests

- Test domain regex with valid/invalid inputs
- Test email regex patterns
- Verify hour range validation
- Test retention days validation"
```

### 1️⃣1️⃣ Chore - Dependências

```bash
git commit -m "chore(deps): update docker-compose version to 2.20

- Update from version 1.29 to 2.20
- Verify compatibility with all stacks
- Test deployment process"
```

### 1️⃣2️⃣ CI/CD - GitHub Actions

```bash
git commit -m "ci: add GitHub Actions workflow for linting

- Add ShellCheck for bash validation
- Run on pull requests
- Prevent merging with lint errors"
```

### 1️⃣3️⃣ Revert - Desfazer Mudança

```bash
git revert <commit-sha> --no-edit

# Ou manualmente:
git commit -m "revert: remove feature X due to incompatibility

This reverts commit abc123.

Reason: Feature caused database initialization failures
in some environments."
```

## 📋 Checklist para Commits

Antes de fazer commit, verifique:

```
[ ] Código testado localmente
[ ] Sem arquivos não rastreados
[ ] Mensagem descritiva e clara
[ ] Tipo de commit apropriado (feat/fix/docs/etc)
[ ] Referência a issues (Closes #XX)
[ ] Documentação atualizada
[ ] CHANGELOG atualizado (se aplicável)
[ ] Sem dados sensíveis (senhas, tokens)
```

## 🔍 Revisar Commits

```bash
# Ver commits recentes
git log --oneline -10

# Ver commit específico
git show <sha>

# Ver diff de um commit
git show <sha> --stat

# Comparar branches
git log develop..feature/nova-feature --oneline
```

## 🚀 Push e Sync

```bash
# Push de um branch
git push origin feature/nova-feature

# Push com tags
git push origin --tags

# Sincronizar com upstream
git fetch upstream
git rebase upstream/develop
git push origin feature/nova-feature --force-with-lease
```

## 📌 Boas Práticas

### ✅ Fazer

```bash
# Commit pequeno e atômico
git commit -m "feat: add validation for domain input"

# Mensagem descritiva
git commit -m "fix: correct backup retention calculation

- Previous formula was off by one day
- Now correctly keeps N days of backups
- Add test case for edge conditions"

# Referenciar issues
git commit -m "fix: improve error message for missing credentials

Fixes #42
Relates to #41"
```

### ❌ Evitar

```bash
# Mensagem vaga
git commit -m "fix stuff"

# Múltiplas mudanças não relacionadas
git commit -m "fix backup and update readme and refactor menu"

# Commits sem contexto
git commit -m "tmp"

# Dados sensíveis
git commit -m "add production password: abc123xyz"
```

## 🎯 Exemplo de PR Completo

```bash
# 1. Create branch
git checkout develop
git pull origin develop
git checkout -b feature/prometheus-alerts

# 2. Make changes
# ... editar arquivos ...

# 3. Stage and commit
git add setup-vps.sh README.md CHANGELOG.md
git commit -m "feat(monitoring): add Prometheus alerting

- Configure AlertManager
- Set up notification channels
- Add documentation"

# 4. Push
git push origin feature/prometheus-alerts

# 5. Create PR on GitHub with:
#    - Clear title
#    - Description of changes
#    - Link to issues
#    - Testing notes

# 6. After review and approval:
git checkout develop
git pull origin develop
git merge --no-ff feature/prometheus-alerts
git push origin develop

# 7. Delete feature branch
git branch -d feature/prometheus-alerts
git push origin --delete feature/prometheus-alerts
```

---

**Última Atualização:** 23 de dezembro de 2025
