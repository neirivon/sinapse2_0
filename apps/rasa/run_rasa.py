"""
Verifica se a porta 5005 está em uso antes de iniciar o Rasa.
"""

import subprocess
import socket
import sys

PORTA = 5005

def porta_esta_em_uso(porta):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        return sock.connect_ex(("localhost", porta)) == 0

def iniciar_rasa():
    print("✅ Iniciando Rasa na porta", PORTA)
    subprocess.run(["rasa", "run", "--enable-api", "--debug"])

if __name__ == "__main__":
    if porta_esta_em_uso(PORTA):
        print(f"🚫 A porta {PORTA} já está em uso!")
        print("👉 Dica: use a task do VS Code 🛑 'Encerrar Rasa na porta 5005' antes de rodar novamente.")
        sys.exit(1)
    else:
        iniciar_rasa()
