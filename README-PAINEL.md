# 🧠 Painel de Controle do Projeto SINAPSE 2.0

Este painel reúne os principais **atalhos de terminal (aliases)** e comandos úteis para facilitar a administração do ecossistema SINAPSE 2.0.

---

## ⚙️ Abertura do Projeto

| Comando        | Descrição                                     |
|----------------|-----------------------------------------------|
| `sinapse`      | Abre o workspace do VS Code com todas as pastas |

---

## 🐳 Docker Compose

| Comando        | Descrição                                     |
|----------------|-----------------------------------------------|
| `dcup`         | Sobe os containers com Docker Compose         |
| `dcdown`       | Encerra os containers                         |
| `dcps`         | Mostra o status dos containers                |

---

## 💾 Backups

| Comando         | Descrição                                  |
|-----------------|--------------------------------------------|
| `backupgraf`    | Cria um backup do banco de dados do Grafana |

---

## 📊 Monitoramento e Logs

| Comando       | Descrição                                        |
|---------------|--------------------------------------------------|
| `rasalogs`    | Acompanha logs do container Rasa (via Docker)    |
| `reloadotel`  | Reinicia o container do OTEL Collector           |

---

## 📂 Acesso rápido a diretórios

| Comando       | Descrição                      |
|---------------|--------------------------------|
| `dashboards`  | Abre a pasta de dashboards     |
| `logs`        | Abre a pasta de logs           |
| `models`      | Abre a pasta de modelos        |

---

## 📌 Dica

Se quiser adicionar novos aliases, edite o arquivo:

```bash
nano ~/sinapse_aliases.sh
```

Depois, recarregue com:

```bash
source ~/.bashrc
```

---

> Atualizado automaticamente por IA no estilo do projeto SINAPSE 2.0 🚀