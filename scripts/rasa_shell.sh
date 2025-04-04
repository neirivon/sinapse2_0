#!/bin/bash
echo "🛑 Encerrando Rasa na porta 5005..."
sudo fuser -k 5005/tcp
sleep 1
echo "💬 Iniciando Rasa em modo shell..."
rasa shell
