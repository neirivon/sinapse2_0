#!/bin/bash

echo "📦 Atualizando repositório SINAPSE 2.0..."

# Solicita mensagem do commit
read -p "📝 Digite a mensagem do commit: " msg

# Adiciona todas as mudanças
git add .

# Faz o commit
git commit -m "$msg"

# Envia para o GitHub
git push origin main

echo "✅ Push concluído com sucesso!"

