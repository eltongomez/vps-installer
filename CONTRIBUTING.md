# Contribuindo para VPS Installer

Obrigado por considerar contribuir! Este documento fornece diretrizes e instruções para contribuir.

## 📋 Código de Conduta

Seja respeitoso e profissional em todas as interações.

## 🚀 Como Contribuir

### Reportar Bugs

1. **Verifique issues existentes** antes de reportar
2. **Use um título descritivo** para o issue
3. **Descreva os passos exatos** para reproduzir
4. **Forneça exemplos específicos** para demonstrar
5. **Inclua sua configuração** (Ubuntu/Debian version, Docker version)

**Template:**
```
**Descrição do bug:**
[Descrição clara e concisa]

**Passos para reproduzir:**
1. ...
2. ...

**Comportamento esperado:**
[O que deveria acontecer]

**Comportamento atual:**
[O que está acontecendo]

**Configuração:**
- OS: [ex: Ubuntu 22.04]
- Docker: [ex: 24.0.0]
- Bash: [ex: 5.1]
```

### Sugerir Enhancements

1. **Use um título descritivo**
2. **Descreva a solução desejada**
3. **Descreva alternativas consideradas**
4. **Forneça contexto e casos de uso**

### Pull Requests

1. **Faça fork do repositório**
2. **Crie uma branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit suas mudanças** (`git commit -m 'Add some AmazingFeature'`)
4. **Push para a branch** (`git push origin feature/AmazingFeature`)
5. **Abra um Pull Request**

## 📝 Padrões de Desenvolvimento

### Branches

```
main              # Produção (releases)
develop           # Desenvolvimento
feature/*         # Novas funcionalidades
bugfix/*          # Correções de bugs
docs/*            # Documentação
hotfix/*          # Hotfixes críticos
```

### Commits

Use commits atômicos com mensagens descritivas:

```bash
# Feature
git commit -m "feat: adiciona suporte a Nextcloud"

# Bugfix
git commit -m "fix: corrige restauração de backup Odoo"

# Documentação
git commit -m "docs: atualiza README com exemplos"

# Refatoração
git commit -m "refactor: simplifica lógica de geração de senhas"

# Tests
git commit -m "test: adiciona testes para opção 8"
```

**Formato:** `type(scope): subject`

### Estilos de Código Bash

```bash
# ✅ BOM
if [[ "$OPTIONS" =~ 8 ]]; then
  echo "Backup configurado"
fi

# ❌ RUIM
if [ "$OPTIONS" = "8" ]; then
  echo "Backup configurado"
fi
```

**Regras:**
- Use `[[ ]]` ao invés de `[ ]`
- Use `=~` para regex matching
- Use `"${var}"` para expansão segura
- Indente com 2 espaços
- Comente funções complexas

## 🧪 Testes

Antes de fazer PR, teste localmente:

```bash
# Teste modo interativo
./setup-vps.sh

# Teste modo não-interativo
NONINTERACTIVE=true NONINTERACTIVE_ENV_FILE=noninteractive.env ./setup-vps.sh

# Valide sintaxe
bash -n setup-vps.sh

# Use ShellCheck
shellcheck setup-vps.sh
```

## 📚 Documentação

- Mantenha README.md atualizado
- Documente novas opções/variáveis
- Inclua exemplos práticos
- Atualize CHANGELOG.md

## 🔐 Segurança

- **Nunca** commita senhas ou credenciais
- Use `.env` para dados sensíveis
- Valide inputs do usuário
- Use `chmod 600` em arquivos sensíveis

## 📞 Dúvidas?

Abra uma issue com a tag `question` ou entre em contato com os mantenedores.

---

**Obrigado por contribuir! 🎉**
