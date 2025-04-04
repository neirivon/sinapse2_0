#!/bin/bash

# Diretórios de origem
GRAFANA_DATA="./docker-data/grafana"
GRAFANA_PROV="./grafana/provisioning"

# Caminhos completos
DESTINO_BACKUP=~/backups/grafana
HASH_ANTERIOR="$DESTINO_BACKUP/.last_backup_hash"
LOG_FILE="$DESTINO_BACKUP/backup.log"

# Verifica se os diretórios existem
if [ ! -d "$GRAFANA_DATA" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') ❌ ERRO: Diretório $GRAFANA_DATA não encontrado!" | tee -a "$LOG_FILE"
  exit 1
fi

# Gera hash atual do conteúdo
HASH_ATUAL=$(tar -cf - "$GRAFANA_DATA" "$GRAFANA_PROV" 2>/dev/null | sha256sum | awk '{print $1}')

# Compara com hash anterior
if [ -f "$HASH_ANTERIOR" ] && grep -q "$HASH_ATUAL" "$HASH_ANTERIOR"; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') 🔁 Nenhuma alteração detectada. Backup ignorado." | tee -a "$LOG_FILE"
  exit 0
fi

# Cria pasta de destino se não existir
mkdir -p "$DESTINO_BACKUP"

# Nome do arquivo com timestamp
ARQUIVO="$DESTINO_BACKUP/grafana_backup_$(date '+%Y-%m-%d_%H-%M-%S').tar.gz"

# Realiza o backup
tar -czf "$ARQUIVO" "$GRAFANA_DATA" "$GRAFANA_PROV" 2>/dev/null

# Atualiza o hash
echo "$HASH_ATUAL" > "$HASH_ANTERIOR"

# Loga a operação
echo "$(date '+%Y-%m-%d %H:%M:%S') ✅ Backup criado: $ARQUIVO" | tee -a "$LOG_FILE"

