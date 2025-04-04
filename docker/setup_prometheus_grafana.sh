#!/bin/bash

# Caminho base
BASE_DIR=~/SINAPSE.2.0
PG_DIR=$BASE_DIR/prometheus-grafana
GRAFANA_DIR=$PG_DIR/grafana/provisioning
DATA_DIR=$PG_DIR/docker-data

# Criação de diretórios com verificação
mkdir -p $GRAFANA_DIR/dashboards
mkdir -p $GRAFANA_DIR/datasources
mkdir -p $DATA_DIR/prometheus
mkdir -p $DATA_DIR/grafana
mkdir -p $BASE_DIR/{redisai,rasa,ollama,mongo,milvus}

# docker-compose.yml
cat <<EOF > $PG_DIR/docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    restart: always
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./docker-data/prometheus:/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    container_name: grafana
    restart: always
    volumes:
      - ./docker-data/grafana:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  dcgm-exporter:
    image: nvidia/dcgm-exporter:3.1.6-3.1.5-ubuntu20.04
    container_name: dcgm-exporter
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - "9400:9400"

networks:
  default:
    driver: bridge
EOF

# prometheus.yml
cat <<EOF > $PG_DIR/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  - job_name: 'dcgm'
    static_configs:
      - targets: ['dcgm-exporter:9400']
EOF

# Datasource Grafana
cat <<EOF > $GRAFANA_DIR/datasources/prometheus-datasource.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    orgId: 1
    url: http://prometheus:9090
    isDefault: true
    version: 1
    editable: true
EOF

# Dashboard provisório (estrutura obrigatória)
cat <<EOF > $GRAFANA_DIR/dashboards/default-dashboard.yml
apiVersion: 1

providers:
  - name: Default
    folder: ''
    type: file
    options:
      path: /etc/grafana/provisioning/dashboards
EOF

echo "✅ Estrutura corrigida e criada com sucesso em: ~/SINAPSE.2.0"
echo "👉 Agora execute:"
echo "   cd ~/SINAPSE.2.0/prometheus-grafana"
echo "   docker compose up -d"
echo "🔐 Acesse Grafana: http://localhost:3000 (login: admin / senha: admin)"

