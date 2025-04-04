#!/bin/bash

# Data e hora atuais
DATA=$(date '+%Y-%m-%d_%H-%M-%S')

# Diretórios
BACKUP_DIR="/home/neirivon/SINAPSE.2.0/backups/grafana"
ORIG_DIR="/home/neirivon/SINAPSE.2.0/docker-data/grafana"
LOG_FILE="/home/neirivon/SINAPSE.2.0/scripts/grafana-backup.log"
ARQUIVO="$BACKUP_DIR/backup_grafana_$DATA.tar.gz"

# Garante que o diretório de backup exista
mkdir -p "$BACKUP_DIR"

# Log de início
echo "[$(date)] Iniciando verificação e backup..." >> "$LOG_FILE"

# Verifica se o diretório original existe
if [ -d "$ORIG_DIR" ]; then
    tar -czf "$ARQUIVO" "$ORIG_DIR" 2>>"$LOG_FILE"
    
    if [ $? -eq 0 ]; then
        echo "[$(date)] ✅ Backup criado com sucesso: $ARQUIVO" >> "$LOG_FILE"
    else
        echo "[$(date)] ❌ ERRO: Falha ao criar backup." >> "$LOG_FILE"
    fi
else
    echo "[$(date)] ⚠️ AVISO: Diretório original $ORIG_DIR não encontrado." >> "$LOG_FILE"
fi

# 🔄 Remove backups com mais de 30 dias
find "$BACKUP_DIR" -name "backup_grafana_*.tar.gz" -mtime +30 -exec rm -f {} \;
echo "[$(date)] 🗑️ Backups antigos (30+ dias) removidos automaticamente." >> "$LOG_FILE"

