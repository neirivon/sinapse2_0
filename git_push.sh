#!/bin/bash

# Carregar variáveis do .env
source .env

# Verifique se o token foi carregado
if [ -z "$GITHUB_PAT" ]; then
  echo "❌ Token GITHUB_PAT não encontrado no .env!"
  exit 1
fi

# Executar push usando HTTPS com token embutido na URL
git remote remove origin 2>/dev/null
git remote add origin https://$GITHUB_PAT@github.com/neirivon/sinapse.git
git push -u origin main

