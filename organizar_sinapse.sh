#!/bin/bash

LOG_FILE="logs/refatoracao.log"
mkdir -p logs
echo "Início da refatoração: $(date)" > "$LOG_FILE"

log_and_exec() {
  local description=$1
  shift
  if "$@"; then
    echo "[OK] $description" | tee -a "$LOG_FILE"
  else
    echo "[ERRO] $description" | tee -a "$LOG_FILE"
  fi
}

# Estrutura de diretórios
log_and_exec "Criando estrutura de diretórios..." sudo mkdir -p \
  apps/{rasa,redisai,ollama,mongo,milvus} \
  config/{grafana/provisioning/{dashboards,datasources},prometheus,otel} \
  data/{grafana,prometheus,backups/grafana} \
  dashboards \
  logs \
  manuais/{NVIDIA+CUDA12.2,OPENTELEMETRY.COLETOR.SINAPSE2,SINAPSE.SERVICE} \
  models/rasa \
  scripts \
  docker

# Movimentos protegidos com verificação
move_if_exists() {
  if [ -e "$1" ]; then
    log_and_exec "Movendo $1 → $2" sudo mv "$1" "$2"
  else
    echo "[IGNORADO] $1 não existe." | tee -a "$LOG_FILE"
  fi
}

# Mover arquivos
move_if_exists docker-compose.yml docker/
move_if_exists Dockerfile.rasa docker/
move_if_exists setup_prometheus_grafana.sh docker/

move_if_exists rasa/ apps/rasa/
move_if_exists redisai/ apps/redisai/
move_if_exists ollama/ apps/ollama/
move_if_exists mongo/ apps/mongo/
move_if_exists milvus/ apps/milvus/

move_if_exists grafana-storage/grafana.db data/grafana/
move_if_exists grafana-storage/plugins data/grafana/
move_if_exists grafana-storage/csv data/grafana/
move_if_exists grafana-storage/pdf data/grafana/
move_if_exists grafana-storage/png data/grafana/

move_if_exists prometheus/config config/prometheus/
move_if_exists prometheus/alerts config/prometheus/
move_if_exists prometheus/prometheus.yml config/prometheus/
move_if_exists prometheus/data data/prometheus/

move_if_exists otel/otel-collector-config-sinapse20.yaml config/otel/
move_if_exists otel/otel-collector-config-backup.yaml config/otel/

move_if_exists backups/grafana data/backups/

move_if_exists MANUAIS.SINAPSE.2.0/* manuais/

move_if_exists scripts/backup_grafana.sh scripts/
move_if_exists scripts/backup_grafana_inteligente.sh scripts/

move_if_exists scripts/grafana-backup.log logs/

move_if_exists prometheus-grafana/dashboards/*.json dashboards/
move_if_exists logs/*.log logs/
move_if_exists rasa/models/* models/rasa/

echo "Refatoração finalizada em: $(date)" >> "$LOG_FILE"
echo -e "\n✅ Refatoração concluída. Verifique o log em: $LOG_FILE"

