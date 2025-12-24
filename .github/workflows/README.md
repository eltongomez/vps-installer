# GitHub Actions Workflows

Este diretório contém os workflows de CI/CD para automação de testes, linting e releases.

## 📋 Workflows Disponíveis

### 1. **test.yml** — Testes Automáticos
**Trigger:** Push em `main`, `develop`, `feature/*`, `bugfix/*` | Pull Requests

**Testes:**
- ✅ ShellCheck Lint - Análise estática do código bash
- ✅ Bash Syntax Validation - Validação de sintaxe
- ✅ Dry Run (Non-Interactive) - Teste de modo não-interativo
- ✅ Markdown Linting - Validação de markdown
- ✅ Documentation Check - Verifica arquivos essenciais
- ✅ Commit Lint - Valida formato de commits convencionais
- ✅ Test Summary - Gera resumo dos testes

**Executa:** Semanalmente (domingo) + em cada push

---

### 2. **lint.yml** — Linting & Style
**Trigger:** Push em `main`, `develop`, `feature/*`, `bugfix/*` | Pull Requests

**Verificações:**
- 🔍 Code Linting - ShellCheck com relatório detalhado
- 🔍 Code Formatting - Verifica line endings, whitespace, indentação
- 🔍 Environment File Validation - Valida `noninteractive.env`
- 🔍 Security Checks - Procura por credenciais hardcoded
- 🔍 CHANGELOG Check - Valida formato do CHANGELOG.md

**Gera:** Artefatos com relatórios detalhados

---

### 3. **release.yml** — Release Automático
**Trigger:** Push de tags `v*` | Workflow Manual

**Ações:**
- 📦 Create Release - Cria release no GitHub automaticamente
- 📖 Update Documentation - Atualiza documentação
- 🔔 Send Notifications - Notifica sobre sucesso da release

**Exemplo de uso:**
```bash
git tag -a v2.1.0 -m "Release v2.1.0"
git push origin --tags
# GitHub Actions cria a release automaticamente
```

---

### 4. **docs.yml** — Documentação
**Trigger:** Push de mudanças em `*.md` | Pull Requests

**Validações:**
- 📚 Validate Markdown - Verifica existência de arquivos de doc
- 🔗 Validate Links - Procura por links quebrados
- ✏️ Spell Check - Identifica typos comuns

---

## 🚀 Como Funciona

### Status Badge (para README)
```markdown
![Tests](https://github.com/eltongomez/vps-installer/workflows/Tests/badge.svg)
![Lint](https://github.com/eltongomez/vps-installer/workflows/Lint%20&%20Style/badge.svg)
![Docs](https://github.com/eltongomez/vps-installer/workflows/Documentation/badge.svg)
```

### Ver Execução dos Workflows
1. Acesse: https://github.com/eltongomez/vps-installer/actions
2. Clique em um workflow para ver detalhes
3. Expanda as etapas (steps) para logs completos

### Estrutura de um Workflow

```yaml
name: Nome do Workflow
on: [trigger eventos]
jobs:
  job-name:
    name: Descrição
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: comando para executar
```

---

## 📊 Pipeline Completo

```
Push / Pull Request
        ↓
    test.yml
    (Syntax, ShellCheck, Dry Run, Docs)
        ↓
    lint.yml
    (Linting, Formatting, Security)
        ↓
    docs.yml
    (Markdown, Links, Spell Check)
        ↓
    Status Summary
    (✅ Pass ou ❌ Fail)
```

---

## 🔧 Variáveis de Ambiente

Workflows podem acessar:
- `${{ github.ref }}` - Branch/Tag atual
- `${{ github.repository }}` - Repositório (owner/repo)
- `${{ github.run_id }}` - ID da execução
- `${{ github.event_name }}` - Tipo de evento

Exemplo:
```yaml
- run: echo "Running on ${{ github.repository }}"
```

---

## 📝 Customizar Workflows

### Adicionar novo teste
1. Edite o arquivo `.yml` correspondente
2. Adicione novo job ou step
3. Commit e push (dispara o workflow)

### Exemplo - Adicionar novo job
```yaml
new-test:
  name: Meu Novo Teste
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - run: echo "Executando meu teste"
```

---

## 🐛 Debug

### Ver logs detalhados
1. Acesse Actions → workflow → última execução
2. Expanda os steps para ver logs completos
3. Procure por ❌ ou ⚠️ para problemas

### Re-executar workflow
1. Acesse a execução do workflow
2. Clique em "Re-run all jobs"
3. Aguarde nova execução

---

## 📞 Troubleshooting

### Workflow não executa
- Verifique se arquivo está em `.github/workflows/`
- Verifique indentação YAML
- Verifique trigger `on:`

### Teste falha localmente mas passa no CI
- Ambientes podem ser diferentes
- Use mesma versão de bash: `bash --version`
- Teste em container: `docker run -it ubuntu:latest bash`

### Permissões
Para operações como `push` ou `release`, garanta:
```yaml
permissions:
  contents: write
```

---

## 📚 Recursos

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Bash Script Best Practices](https://mywiki.wooledge.org/BashGuide)
- [ShellCheck](https://www.shellcheck.net/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**VPS Installer CI/CD** | Totalmente Automatizado ✅
