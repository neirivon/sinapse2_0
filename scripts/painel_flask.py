from flask import Flask, render_template_string, send_from_directory
import os

app = Flask(__name__)

# Caminho para a pasta onde está a logo e o HTML dinâmico
BASE_DIR = os.path.expanduser("~/SINAPSE.2.0/docs")

# Carrega o conteúdo HTML do painel dinâmico
with open(os.path.join(BASE_DIR, "painel-controle-sinapse-dinamico.html"), "r", encoding="utf-8") as f:
    painel_html = f.read()

@app.route("/")
def index():
    return render_template_string(painel_html)

@app.route("/<path:filename>")
def static_files(filename):
    return send_from_directory(BASE_DIR, filename)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
