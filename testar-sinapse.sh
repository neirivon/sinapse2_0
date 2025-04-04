#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/sinapse-$(date +%Y-%m-%d_%H-%M-%S).log"
mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

function check_url() {
  local url=$1
  if curl -s -H "User-Agent: Mozilla" --max-time 3 "$url" > /dev/null; then
    echo "✅ OK"
  else
    echo "❌ Falhou"
  fi
}

function log_header() {
  echo ""
  echo "🔍 $1"
}

log_header "Verificando containers em execução..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

log_header "Verificando status de saúde (healthcheck)..."
for c in $(docker ps -q); do
  name=$(docker inspect --format='{{ .Name }}' "$c" | cut -c2-)
  health=$(docker inspect --format='{{ .State.Health.Status }}' "$c" 2>/dev/null || echo "sem healthcheck")
  echo "$name => $health"
done

log_header "Testando endpoints principais via localhost..."

URLS=(
  "http://localhost:9090"              # Prometheus
  "http://localhost:3000"              # Grafana
  "http://localhost:5005/status"       # Rasa
  "http://localhost:9121/metrics"      # RedisAI Exporter
  "http://localhost:9400/metrics"      # DCGM Exporter
  "http://localhost:8889/metrics"      # OTEL Collector
)

for url in "${URLS[@]}"; do
  echo -n "🔗 $url ... "
  check_url "$url"
done

log_header "Validando targets no Prometheus:"
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health, scrapeUrl: .scrapeUrl}' 2>/dev/null || echo "⚠️ Não foi possível acessar o endpoint do Prometheus."

log_header "📦 Logs salvos em: $LOG_FILE"

