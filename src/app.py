import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Kubernetes Auto-Healing with GitOps is Running!"

@app.route("/health")
def health_check():
    return "OK", 200

@app.route("/ready")
def readiness_check():
    return "Ready", 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)

