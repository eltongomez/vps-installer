#!/bin/bash

# Diagnóstico Completo dos Workflows
echo "🔍 DIAGNÓSTICO DE WORKFLOWS - VPS INSTALLER"
echo "=========================================="
echo "Data: $(date)"
echo ""

# 1. Validar Bash
echo "1️⃣ VALIDAÇÃO BASH"
if bash -n setup-vps.sh 2>&1; then
    echo "   ✅ Sintaxe bash válida"
else
    echo "   ❌ Erro de sintaxe bash"
fi

# 2. Validar YAML
echo ""
echo "2️⃣ VALIDAÇÃO YAML"
if python3 -c "import yaml; import sys; [yaml.safe_load(open(f)) for f in ['.github/workflows/test.yml', '.github/workflows/lint.yml', '.github/workflows/docs.yml', '.github/workflows/release.yml']]" 2>&1; then
    echo "   ✅ Todos os workflows têm YAML válido"
else
    echo "   ⚠️  Verifique YAML dos workflows"
fi

# 3. Arquivos Necessários
echo ""
echo "3️⃣ ARQUIVOS NECESSÁRIOS"
required_files=(
    "README.md"
    "README_PROJETO.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "CHANGELOG.md"
    "setup-vps.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file (MISSING!)"
    fi
done

# 4. Permissões
echo ""
echo "4️⃣ PERMISSÕES"
if [ -x setup-vps.sh ]; then
    echo "   ✅ setup-vps.sh é executável"
else
    echo "   ⚠️  setup-vps.sh não é executável"
    chmod +x setup-vps.sh
    echo "   ✅ Corrigido"
fi

# 5. Linhas de Código
echo ""
echo "5️⃣ ESTATÍSTICAS"
echo "   📝 setup-vps.sh: $(wc -l < setup-vps.sh) linhas"
echo "   📚 Arquivos markdown: $(find . -name "*.md" | wc -l) arquivos"

# 6. Git Status
echo ""
echo "6️⃣ GIT STATUS"
git log --oneline -1
echo "   Branch: $(git rev-parse --abbrev-ref HEAD)"

echo ""
echo "=========================================="
echo "✅ Diagnóstico concluído!"
