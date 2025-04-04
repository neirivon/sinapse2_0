#!/bin/bash

echo "🛑 Encerrando processos na porta 5005..."
sudo fuser -k 5005/tcp

echo "🧠 Iniciando Rasa Server com API e Debug..."
cd ~/SINAPSE.2.0/apps/rasa || exit
rasa run --enable-api --debug

