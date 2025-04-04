#!/bin/bash

echo "📦 Atualizando repositório SINAPSE 2.0..."

# ⚠️ Verifica se sinapse-clean é um repositório Git e remove do rastreamento
if [ -d "sinapse-clean/.git" ]; then
  echo "⚠️  Detectado repositório Git embutido em 'sinapse-clean/'. Removendo do controle de versão..."
  git rm --cached sinapse-clean > /dev/null 2>&1
fi

# ➕ Garante que 'sinapse-clean/' esteja no .gitignore
if ! grep -qxF "sinapse-clean/" .gitignore; then
  echo "➕ Adicionando 'sinapse-clean/' ao .gitignore..."
  echo "sinapse-clean/" >> .gitignore
  git add .gitignore
  git commit -m "🚫 Atualiza .gitignore para ignorar 'sinapse-clean/'"
fi

# 📝 Solicita a mensagem de commit
echo -n "📝 Digite a mensagem do commit: "
read mensagem

# 📂 Adiciona mudanças e faz o commit
git add .
git commit -m "$mensagem"

# 🚀 Envia para o GitHub
git push origin main

echo "✅ Push concluído com sucesso!"

